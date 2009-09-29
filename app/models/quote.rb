class Quote < ActiveRecord::Base
  set_table_name 'orders'
  set_inheritance_column 'foo'
  
  belongs_to :organisation, :foreign_key => 'org_id'
  
  def organisation_name
    organisation.name
  end
  
  def initialize *args
    super
    self.created_date ||= Date.today
  end
end
