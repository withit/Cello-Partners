class Quote < ActiveRecord::Base
  set_table_name 'orders'
  set_inheritance_column 'foo'
  
  belongs_to :organisation, :foreign_key => 'org_id'
  belongs_to :grade
  def organisation_name
    organisation.name
  end
  
  def initialize *args
    super
    self.created_date ||= Date.today
  end

  def calliper_options
    return [] unless grade
    grade.callipers
  end
  
  def grade
    Grade.find_by_grade_abbrev(grade_abbrev)
  end
  
  def gross_weight
  end
  
  def ex_reels
    reel = reels.to_a.min do |a,b|
      a.weight_per_unit_length(width) <=> b.weight_per_unit_length(width)
    end
    reel && reel.reel_size
  end
  
  def reels
    Reel.find_all_by_grade_abbrev_and_calliper(grade_abbrev, calliper)
  end
  
  def cost_per_1000_sheets
  end
end
