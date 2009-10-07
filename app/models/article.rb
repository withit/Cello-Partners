require 'rexml/document'
require 'enumerator'

class Article < ActiveRecord::Base
  set_table_name 'article'
  set_primary_key 'ID'
  
  has_and_belongs_to_many :sections, :join_table => 'article_to_section', :foreign_key => 'ArticleID', :association_foreign_key => 'SectionID', :uniq => true, :select => 'sections.*'
  
  (1..8 ).each do |i|
    attr_accessor "keyword_#{i}"
  end
  self.columns.collect(&:name).each do |column_name|
    next unless column_name =~ /[A-Z]/
    define_method column_name.underscore do
      self.send(column_name)
    end
    
    define_method "#{column_name.underscore}=" do |new_value|
      self.send("#{column_name}=", new_value)
    end
  end
  
  belongs_to :author, :foreign_key => 'AUTHOR', :class_name => 'User'
  
  def author_name
    author.full_name
  end
  
  def documents
    @documents ||= load_documents
  end
  
  def set_keywords
    self.keywords = keywords_to_xml
  end
  
  def all_keywords
    (1..8).collect{|i| instance_variable_get "@keyword_#{i}"}.compact
  end
  
  def keyword_list
    all_keywords * ' '
  end
  
  def keywords_to_xml
    xml = "<keywords>\r\n" 
    (1..8).each do |i|
      keyword = instance_variable_get "@keyword_#{i}"
      xml << (keyword ? "\t<kw>#{ERB::Util.h(keyword)}</kw>\r\n" : "\t<kw />\r\n")
    end
    xml << "</keywords>\r\n"
  end
  
  before_save :set_keywords
  
  def links
    @links ||= load_links
  end
  
  def load_documents
    REXML::Document.new(self.AssocDocuments).elements.collect('*/document') do |document|
      Document.new(
        document.attributes['ID'].to_i,
        document.text('filename'),
        document.text('filetype')
      )
    end
  end
  
  def build_document_xml
    xml = "<documents>\r\n"
    documents.reject{|d| d.marked_for_destruction?}.each do |document|
      xml << "\t<document ID=\"#{ERB::Util.h(document.id)}\">\r\n"
      xml << "\t\t<filename>#{ERB::Util.h(document.filename)}</filename>\r\n"
      xml << "\t\t<filetype>#{ERB::Util.h(document.filetype)}</filetype>\r\n"
      xml << "\t</document>\r\n"
    end
    xml << "</documents>\r\n"
  end

  def build_link_xml
    xml = "<links>\r\n"
    links.each do |link|
      xml << "\t<link ID=\"#{ERB::Util.h(link.id)}\">\r\n"
      xml << "\t\t<name>#{ERB::Util.h(link.label)}</name>\r\n"
      xml << "\t\t<url>#{ERB::Util.h(link.url)}</url>\r\n"
      xml << "\t\t<target>#{ERB::Util.h(link.target)}</target>\r\n"
      xml << "\t</link>\r\n"
    end
    xml << "</links>\r\n"
  end
  
  def load_links
    REXML::Document.new(self.AssocWebPages).elements.collect('*/link') do |link|
      Link.new(
        link.attributes['ID'].to_i,
        link.text('name'),
        link.text('url'),
        link.text('target')
      )
    end
  end
  
  def load_keywords
    REXML::Document.new(self.keywords).elements.to_a('*/kw').each_with_index do |k,i|
      instance_variable_set "@keyword_#{i+1}",k.text
    end
  end
  
  def set_documents
    self.assoc_documents = build_document_xml if @documents
  end

  def set_web_pages
    self.assoc_web_pages = build_link_xml if @links
  end
  
  before_save :set_documents, :set_web_pages

  def link_attributes= link_attributes
    @links = link_attributes.to_enum(:each_with_index).collect do |attributes, id|
      Link.new(id + 1, attributes[:label], attributes[:url], attributes[:target]) unless attributes[:label].blank? && attributes[:url].blank? && attributes[:target].blank?
    end.compact
  end
  
  def new_document_attributes= document_attributes
    document_attributes.each do |attributes|
      documents << Document.new(next_document_id, attributes[:filename], attributes[:filetype], attributes[:file]) unless attributes[:filename].blank? && attributes[:filetype].blank? && attributes[:file].blank?
    end
  end
  
  def next_document_id
    current_id = documents.empty? ? 0 : documents.last.id
    current_id + 1
  end

  def document_ids_to_delete= ids
    documents.each do |document| 
      document.destroy if ids.include?(document.id.to_s)
    end
  end

  def after_find
    load_keywords
  end

  def clean_up_files_for_documents
    documents.each do |document|
      path = document_path(document)
      if document.marked_for_destruction?
        File.delete(path) if File.file?(path)
      end

      if document.file
        FileUtils.mkdir_p("#{RAILS_ROOT}/documents/#{id}")
        FileUtils.mv(document.file.path, path)
      end
    end
  end
  
  def document_path document
    "#{RAILS_ROOT}/documents/#{id}/#{document.filename}#{document.filetype}"
  end
  
  def find_document(id)
    documents.find{|d| d.id == id.to_i} || raise(ActiveRecord::RecordNotFound) 
  end
  
  after_save :clean_up_files_for_documents

  class Document < Struct.new(:id, :filename, :filetype, :file)
    FORMATS = [
      ['Word (.doc)','.doc'],
      ['Excel (.xls)','.xls'],
      ['Powerpoint (.ppt)','.ppt'],
      ['Acrobat (.pdf)','.pdf']
    ]
    
    def destroy
      @marked_for_destruction = true
    end
    
    def name_with_extention
      filename.to_s + filetype.to_s
    end
    
    def marked_for_destruction?
      @marked_for_destruction
    end
    
    def to_param
      return unless id
      "#{id}-#{filename.parameterize}-#{filetype.parameterize}"
    end
  end
  
  class Link < Struct.new(:id, :label, :url, :target)
    TARGETS = [
      ["Window", '_top'],
      ["New Window", '_blank'],
      ['The Content Frame', 'content']
    ]
  end
end
