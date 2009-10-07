class Role < ActiveRecord::Base
  set_table_name :shell_groups
  set_primary_key :Group_ID
  
  has_many :grants, :foreign_key => 'User_Group_ID'
  has_many :permissions, :through => :grants
  has_many :privileges, :foreign_key => "Group_ID"
  has_many :users, :through => :privileges
  
  validates_presence_of :Name, :description, :owner
  validates_uniqueness_of :Name
  
  self.columns.collect(&:name).each do |column_name|
    next unless column_name =~ /[A-Z]/
    define_method column_name.underscore do
      self.send(column_name)
    end
    
    define_method "#{column_name.underscore}=" do |new_value|
      self.send("#{column_name}=", new_value)
    end
  end
  
  has_and_belongs_to_many :sections, :join_table => 'sections_to_groups', :foreign_key => 'Group_ID', :association_foreign_key => 'Section_ID', :select => 'sections.*'
end
