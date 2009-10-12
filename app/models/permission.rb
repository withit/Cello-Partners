class Permission < ActiveRecord::Base
  set_table_name :shell_option_sets
  
  has_many :grants, :foreign_key => 'Option_set_ID'
  has_many :roles, :through => :grants
  
  #has_many :children, :foreign_key => 'parent', :order => 'sort'
  # has_many :actions
  belongs_to :action, :foreign_key => 'default_first_option'
  
  def module
    self.Module
  end
  
  def function
    self.Function
  end
  def url
    case 
    when self.module == 'shell_editmyself'
      path('profiles', 'edit')
    when self.module == 'shell_user_mgr' && self.function == 'nrform'
      path('users','new')
    when self.module == 'shell_user_mgr' && self.function == 'sform'
      path('users','search')
    when self.module == 'quotes' && self.function == 'nrform'
      path('quotes','new')
    when self.module == 'quotes' && self.function == 'sform'
      path('quotes','index')
    when self.module == 'shell_group_mgr' && self.function == 'nrform'
      path('roles','new')
    when self.module == 'shell_group_mgr' && self.function == 'edit'
      path('roles','index')
    when self.module == 'article_publishing' && self.function == 'list'
      path('articles','index')
    when self.module == 'article_publishing' && self.function == 'form'
      path("templates",'index')
    when self.module == 'load_pricing_data' && self.function == 'form'
      path("prices", "new")
    when self.module == 'load_reels' && self.function == 'form'
      path("reels","new")
    else 
    end
  end
  
  def path controller, action
    {:controller => controller, :action => action}
  end
end
