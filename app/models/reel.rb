class Reel < ActiveRecord::Base
  set_table_name 'product_reels'
  
  def self.callipers
    scoped(:select => "distinct grade_abbrev, calliper", :conditions => "calliper is not null", :order => 'calliper')
  end
  
  def calliper_with_units
    "#{calliper} μm"
  end
  
  def pages_per_unit_length page_width
    reel_size / page_width 
  end
  
  def weight_per_unit_length page_width
    gsm / pages_per_unit_length(page_width)
  end
end
