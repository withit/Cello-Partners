class Address < ActiveRecord::Base
  set_table_name 'org_addresses'
  
  belongs_to :organisation, :foreign_key => 'org_id'
  has_many :orders, :class_name => 'Quote'
  def label
    [st_address1, st_address2, st_city] * ' '
  end
  
  def organisation_name
    organisation.name
  end
  
  def first_line
    [st_address1,st_address2] * ' '
  end
  
  def second_line
    [st_city, st_state, st_postcode, st_country] * ' '
  end
  
  def status_label status=status
    status == 1 ? 'Active' : 'Inactive'
  end
  
  def status_options
    [1,0].collect do |i|
      [status_label(i),i]
    end
  end
  
  validates_presence_of :organisation, :address1, :city, :state, :postcode, :country, :phone, :description, :unless => :skip_validation
  
  attr_accessor :skip_validation
  
  [:address1, :city, :state, :postcode, :country].each do |attribute|
    define_method attribute do
      send("st_#{attribute}")
    end
    
    define_method "#{attribute}=" do |new_value|
      send("st_#{attribute}=", new_value)
    end
  end
end
