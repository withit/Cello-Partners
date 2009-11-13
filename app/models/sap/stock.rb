module Sap
  class Stock < ActiveRecord::Base
    if Rails.env.production?
      self.establish_connection :sap_production
    else
      self.establish_connection :sap_development
    end
    
    set_table_name "OITW"

    def self.find_by_item_code code
      find(:first, :conditions => ["ItemCode = ? and OnHand > 0", code])
    end
    
    def available
      self.OnHand - self.IsCommited
    end
    
  end
end