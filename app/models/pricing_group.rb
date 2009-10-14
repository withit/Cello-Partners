class PricingGroup < ActiveRecord::Base
  belongs_to :pricing_group_name, :foreign_key => 'group_name_id'
  belongs_to :pricing_line, :foreign_key => 'price_id'
  delegate :name, :to => :pricing_group_name
  
  def pricing_name
    pricing_line.name
  end
  
  def status_label
    status == 1 ? 'Active' : 'Inactive'
  end
  
  def max_sort
    group_name_id ? self.class.count(:conditions => {:group_name_id => group_name_id}) : 1
  end
end
