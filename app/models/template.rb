require 'enumerator'

class Template   # def self.all
  #   ["Free Text Only", "Free Text + 1 Image", "Free Text + 1 Image", "Free Text + 1 Image", "Free Text + 2 Image", "HTML"].to_enum(:each_with_index).collect do |description, index|
  #     new(index + 2, description)
  #   end << FreeTextTemplate.new(7, "Free Text Only")
  # end
  attr_reader :id, :description, :image_numbers
  
  include Singleton
  
  def self.all
    subclasses.collect do |subclass_name|
      subclass_name.constantize.instance
    end.sort
  end
  
  def self.find id
    all.find{|t| t.id == id.to_i} || raise(ActiveRecord::RecordNotFound)
  end
  
  def <=> other
    id <=> other.id
  end
  
  def to_param
    "#{id}-#{description.parameterize}"
  end
  
  def image_url
    "/images/templates/template#{id}.gif"
  end
end

class FreeTextTemplate < Template
  def initialize
    @id =  1
    @description = "Free Text Only"
    @image_numbers = [nil]
  end
end

class LeftImageTemplate < Template
  def initialize
    @id =  2
    @description = "Free Text + 1 Image"
    @image_numbers = [1]
  end
end

class WideImageTemplate < Template
  def initialize
    @id =  3
    @description = "Free Text + 1 Image"
    @image_numbers = [1]
  end
end

class RightImageTemplate < Template
  def initialize
    @id =  4
    @description = "Free Text + 1 Image"
    @image_numbers = [1]
  end
end

class TwoImagesTemplate < Template
  def initialize
    @id = 5
    @description = "Free Text + 2 Image"
    @image_numbers = [1,2]
  end
end

class HtmlTemplate < Template
  def initialize
    @id = 6
    @description = "HTML"
    @image_numbers = [nil]
  end
end