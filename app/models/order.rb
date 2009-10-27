class Order < OrderOrQuote
  def possible_addresses
    organisation.addresses
  end
  before_save :set_address_organisation
  belongs_to :address #, :before_build => :set_address_org
  accepts_nested_attributes_for :address
  
  attr_accessor :authorizer_name
  
  def set_address_organisation
    address.organisation = organisation if address && address.new_record?
  end
  
  def existing_address_id
    address_id
  end
  
  def existing_address_id= new_existing_address_id
    self.address_id = new_existing_address_id unless new_existing_address_id.blank?
  end
  
  def initialize attributes={}, *args
    super
    self.created_date ||= Date.today
    self.status ||= 1
  end
  
  def self.deliver_report
    Notifier.deliver_order_report(report)
  end
  
  def required_date_as_string
    required_date && required_date.strftime('%d/%m/%y')
  end
  
  def required_date_as_string= new_date
    self.required_date = Date.strptime(new_date, '%d/%m/%y')
  rescue 
    @request_date_invalid = true
  end
end
