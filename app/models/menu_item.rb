class MenuItem  
  attr_reader :label, :permission
  def initialize grant, permission
    @permission = permission
    @label = grant.Label
    @children = []
  end
  
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
  
  def children
    @children.sort
  end
  
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
    else 
      nil
    end
  end
end