class Menu
  def initialize
    @root_items = []
  end
  
  def add_root_item menu_item
    if menu_item.root?
      @root_items << menu_item unless @root_items.include? menu_item
    else
      raise "Not a root item"
    end
  end
  
  def add_child_item menu_item
    if menu_item.root?
      raise "Root item added as a child"
    else
      parent = @root_items.find{|i| i.permission.id == menu_item.parent}
      parent.add_child(menu_item) if parent
    end
  end
  
  def root_items
    @root_items.sort
  end
end