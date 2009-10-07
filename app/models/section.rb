class Section < ActiveRecord::Base
  has_and_belongs_to_many :articles, :join_table => 'article_to_section', :foreign_key => 'SectionID', :association_foreign_key => 'ArticleID'
  
    has_and_belongs_to_many :roles, :join_table => 'sections_to_groups', :foreign_key => 'Section_ID', :association_foreign_key => 'Group_ID'
end
