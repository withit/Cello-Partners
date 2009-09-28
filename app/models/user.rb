require 'digest/md5'

class User < ActiveRecord::Base
  set_table_name "shell_users"
  set_primary_key 'User_ID'
  
  attr_accessor :comments
  
  def self.find_by_username username
    first(:conditions => {:Username => username})
  end
  
  def password
    self.Password
  end
  has_many :privileges
  has_many :roles, :through => :privileges
  #has_many :permissions, :through => :roles
  
  def menu_items
    effective_roles.uniq.collect do |role|
      role.grants(:include => :permission, :conditions => {:is_menu => true})
    end.flatten.uniq
  end
  
  def root_menu_items
    menu_items.select(&:root?)
  end
  
  def child_menu_items
    menu_items.select{|e| !e.root?}
  end
  
  def menu_items
    effective_roles.uniq.collect do |role|
      role.grants.all(:joins => :permission, :conditions => ["is_menu = ? and first_option is not null",true], :order => :sort).flatten.collect do |g|
        MenuItem.new(g, g.permission)
      end
    end.flatten.uniq.sort
  end
  
  def menu
    menu = Menu.new
    root_menu_items.each do |menu_item|
      menu.add_root_item menu_item
    end
    child_menu_items.each do |menu_item|
      menu.add_child_item menu_item
    end
    menu
  end
  
  def effective_roles 
    id == 1 ? Role.all : roles
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
  
  attr_accessor :new_password
  validates_confirmation_of :new_password
  
  before_save :set_password
  
  def set_password
    self.Password = Digest::MD5.hexdigest(new_password) unless new_password.blank?
  end
  
end
