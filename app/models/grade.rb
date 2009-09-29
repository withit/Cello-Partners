class Grade < ActiveRecord::Base
  set_table_name 'product_grades'
  
  def callipers
    Reel.callipers.scoped(:conditions => {:grade_abbrev => grade_abbrev})
  end
end
