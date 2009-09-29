class Reel < ActiveRecord::Base
  set_table_name 'product_reels'
  
  def self.callipers
    all(:select => "distinct grade_abbrev, calliper", :conditions => "calliper is not null", :order => 'calliper')
  end
  
  def calliper_with_units
    "#{calliper} μm"
  end
end
