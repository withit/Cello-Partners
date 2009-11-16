class Organisation < ActiveRecord::Base
  set_table_name 'shell_organisations'
  has_many :users, :foreign_key => 'Organisation'
  has_many :quotes, :foreign_key => 'org_id'
  has_many :orders, :foreign_key => 'org_id'
  has_many :orders_and_quotes, :foreign_key => 'org_id', :class_name => 'OrderOrQuote'
  belongs_to :pricing_group_name, :foreign_key => 'pricing_group_id'
  belongs_to :rep, :class_name => 'User', :foreign_key => 'cello_rep_id'
  
  def rep_name
    rep && rep.full_name
  end
  
  def price_names
    PricingLine.all(:joins => {:pricing_groups => {:pricing_group_name => :organisations }}, :conditions => ['shell_organisations.id = ?',id], :select => 'pricing_lines.name').collect(&:name)
  end

  def price_lines
    PricingLine.scoped(:joins => {:pricing_groups => {:pricing_group_name => :organisations }}, :conditions => ['shell_organisations.id = ?',id])
  end
  
  def grades
    Grade.scoped(:conditions => {:grade_abbrev => price_lines.collect(&:grade_abbrev)})
  end

  has_many :addresses, :foreign_key => 'org_id'
  
  def customer_code
    self.Cello_cust_code
  end
  
  def customer_code=new_code
    self.Cello_cust_code = new_code
  end
  def price_group_label
    pricing_group_name && pricing_group_name.name
  end
  
  def status_label status=status
    status == 1 ? 'Active' : 'Inactive'
  end
  
  def status_options
    [1,0].collect do |i|
      [status_label(i),i]
    end
  end
  
  def price_group_options user
     if user.is_cello_admin?
        PricingGroupName.find_all_by_status(true)
     else
       PricingGroupName.find_all_by_name('Standard')
     end
  end
  
  default_scope :order => 'name'
  
  def grade_options
    Grade.all(:select => 'distinct product_grades.*', :conditions => [
      "shell_organisations.pricing_group_id = pricing_groups.group_name_id and 
       pricing_groups.price_id = pricing_lines.id and 
       pricing_lines.name = pricing_data.name and 
       pricing_data.grade_abbrev = product_grades.grade_abbrev and
      product_grades.status = 1 and shell_organisations.id = ?", id], :from => "shell_organisations, pricing_groups, pricing_lines, product_grades, pricing_data", :order => 'pricing_groups.sort')
  end
end
