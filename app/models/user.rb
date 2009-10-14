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
  has_many :privileges, :foreign_key => 'User_ID'
  has_many :roles, :through => :privileges, :uniq => true
  #has_many :permissions, :through => :roles
  
  def permissions
    Permission.scoped(:joins => {:grants => {:role => {:privileges => :user}}}, :conditions => ['shell_users.User_ID = ?',id])
  end
  
  def actions
    Action.scoped(:joins => {:permission => {:grants => {:role => {:privileges => :user}}}}, :conditions => ['shell_users.User_ID = ?',id])
  end
  
  def has_access_to? mod, func
    return true if id == 1
    actions.find(:first, :conditions => ['shell_options.Module = ? and shell_options.Function = ?',mod, func])
  end
  
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
  
  def find_child_menu_items
    Permission.scoped(
      :joins => [:grants, :action], 
      :conditions => ["shell_permissions.User_Group_ID IN (?) and shell_permissions.is_menu = ? and shell_option_sets.parent != 0", role_ids.uniq, true],
      :select => "shell_permissions.*, shell_option_sets.*, shell_options.*"
    )
  end
  
  def find_root_menu_items
    Permission.scoped(
      :joins => [:grants, :action], 
      :conditions => ["shell_permissions.User_Group_ID IN (?) and shell_permissions.is_menu = ? and shell_option_sets.parent = 0", role_ids.uniq, true],
      :select => "shell_permissions.*, shell_option_sets.*, shell_options.*"
    )
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
    super_admin? ? Role.all : roles
  end
  

  def super_admin?
    id == 1
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
  
  belongs_to :organisation, :foreign_key => 'Organisation'
  
  def organisation_name
    organisation && organisation.name
  end
  
  def full_name
    "#{first_name} #{last_name}"
  end
  
  def is_customer?
    return false if super_admin?
    roles.count(:conditions => "name like 'Cello%'").zero?
  end
  
  def articles
    Article.scoped(:joins => {:sections => :roles}, :select => 'distinct article.*', :conditions => ['shell_groups.Group_ID in (?)', role_ids.uniq])
  end
  
  named_scope :rep, :conditions => {:cello_rep => 1}
  
  def can_access? module_name, function_name
    return true if super_admin?
    actions.find_by_Module_and_Function(module_name, function_name)
  end
end
