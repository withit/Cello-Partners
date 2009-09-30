class Organisation < ActiveRecord::Base
  set_table_name 'shell_organisations'
  has_many :users, :foreign_key => 'Organisation'
  has_many :quotes, :foreign_key => 'org_id'
  
  belongs_to :pricing_group_name, :foreign_key => 'pricing_group_id'
  
  def price_names
    PricingLine.all(:joins => {:pricing_groups => {:pricing_group_name => :organisations }}, :conditions => ['shell_organisations.id = ?',id], :select => 'pricing_lines.name').collect(&:name)
  end
end
