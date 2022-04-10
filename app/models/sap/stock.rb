module Sap
  class Stock < ActiveRecord::Base
    if Rails.env.production?
      self.establish_connection :sap_production
    else
      self.establish_connection :sap_production
    end

    set_table_name "OITW"

    def self.find_by_item_code code
      find(:first, :conditions => ["ItemCode = ? and WhsCode = ?", code, 'SYD'])
      # if Rails.env.production?
      #   find(:first, :conditions => ["ItemCode = ? and WhsCode = ?", code, 'SYD'])
      # else
      #
      #   return x
      # end

    end

    def available
      self.OnHand - self.IsCommited
      # if Rails.env.production?
      #   self.OnHand - self.IsCommited
      # else
      #   # dummy for the development testing
      #   10
      # end
    end


  end
end