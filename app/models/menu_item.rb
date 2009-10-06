class MenuItem  
  #attr_reader :label, :permission
  #attr_accessor :children
  # def initialize grant, permission
  #   @permission = permission
  #   @label = grant.Label
  #   @children = []
  # end
  
  def sort
    @permission.sort || -1
  end
  
  def parent
    @permission.parent
  end
  
  def root?
    permission.parent && permission.parent.zero?
  end
  
  def <=> other
    (sort <=> other.sort).nonzero? || label <=> other.label
  end
  
  
  def == other
    label.to_s.downcase == other.label.to_s.downcase && permission == other.permission
  end
  
  def add_child menu_item
    @children << menu_item unless @children.include? menu_item
  end
  
  # def children
  #   @children.sort
  # end
  
  def module 
    permission.action.module
  end
  
  def function
    permission.action.function
  end
  
  def url
    return unless permission.action
    case 
    when self.module == 'shell_editmyself'
      lambda{edit_profile_path}
    when self.module == 'shell_user_mgr' && self.function == 'nrform'
      lambda{new_user_path}
    when self.module == 'shell_user_mgr' && self.function == 'sform'
      lambda{search_users_path}
    when self.module == 'quotes' && self.function == 'nrform'
      lambda{new_quote_path}
    when self.module == 'quotes' && self.function == 'sform'
      lambda{search_quotes_path}
    when self.module == 'shell_group_mgr' && self.function == 'nrform'
      lambda{new_role_path}
    when self.module == 'shell_group_mgr' && self.function == 'edit'
      lambda{roles_path}
    else 
      nil
    end
  end
  
  def self.find
    Permission.scoped(
      :joins => [:grants, :action], 
      :select => "distinct shell_permissions.Label as label, shell_option_sets.*, shell_options.*",
      :conditions => ['shell_permissions.is_menu = ?',true],
      :order => 'shell_option_sets.sort, shell_permissions.Label'
      )
  end
  
  def self.root
    find.scoped(:conditions => "shell_option_sets.parent = 0")
  end
  
  def self.child
    find.scoped(:conditions => "shell_option_sets.parent != 0")
  end
  
  def self.build_for(user)
    if user.super_admin?
      root_items = root
      child_items = child
    else
      root_items = root.scoped(:conditions => ["shell_permissions.User_Group_ID IN (?)", user.role_ids.uniq])
      child_items = child.scoped(:conditions => ["shell_permissions.User_Group_ID IN (?)", user.role_ids.uniq])
    end
    grouped_children = child_items.group_by(&:parent)
    root_items.collect do |root_item|
      MenuItem.new(root_item,grouped_children[root_item.id])
    end
  end
  
  def initialize root, children
    @root = root
    @children = children
  end
  
  def label
    @root.label
  end
  
  attr_reader :children
  # def find_child_menu_items
  #   Permission.scoped(
  #     :joins => [:grants, :action], 
  #     :conditions => ["shell_permissions.User_Group_ID IN (?) and shell_permissions.is_menu = ? and shell_option_sets.parent != 0", role_ids.uniq, true],
  #     :select => "shell_permissions.*, shell_option_sets.*, shell_options.*"
  #   )
  # end
  # 
  # def find_root_menu_items
  #   Permission.scoped(
  #     :joins => [:grants, :action], 
  #     :conditions => ["shell_permissions.User_Group_ID IN (?) and shell_permissions.is_menu = ? and shell_option_sets.parent = 0", role_ids.uniq, true],
  #     :select => "shell_permissions.*, shell_option_sets.*, shell_options.*"
  #   )
  # end
  
  
  
end