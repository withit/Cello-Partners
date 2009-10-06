class Order < OrderOrQuote
  def possible_addresses
    organisation.addresses
  end
  before_save :set_address_organisation
  belongs_to :address #, :before_build => :set_address_org
  accepts_nested_attributes_for :address
  
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
end
