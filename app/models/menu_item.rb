class MenuItem  
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
end