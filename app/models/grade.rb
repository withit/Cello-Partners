class Grade < ActiveRecord::Base
  set_table_name 'product_grades'
  
  def callipers
    Reel.callipers.scoped(:conditions => {:grade_abbrev => grade_abbrev})
  end
  
  def self.callipers_for_abbrev abbrev
    grade = find_by_grade_abbrev(abbrev)
    grade ? grade.callipers : []
  end
  
  default_scope :order => :name
end
