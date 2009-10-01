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
    reel && (reel.weight_per_unit_length(width) * length * sheets) / 10**9
  end
  
  def ex_reels
    reel && reel.reel_size
  end
  
  def reel
    @reel ||= reels.to_a.min do |a,b|
      a.weight_per_unit_length(width) <=> b.weight_per_unit_length(width)
    end
  end
  
  def reels
    return unless grade_abbrev && calliper
    Reel.reel_size_greater_than(width).find_all_by_grade_abbrev_and_calliper(grade_abbrev, calliper)
  end
  
  def prices
    Price.scoped(:conditions => {:status => true, :grade_abbrev => grade_abbrev, :calliper => calliper, :name => organisation.price_names})
  end
  
  def rate
    p = prices.break_less_than(gross_weight).first(:order => "break desc", :select => 'price')
    p && p.price
  end
  
  def price_per_1000_sheets
    rate && rate * gross_weight * 1000 / sheets
  end
  
  belongs_to :creator, :class_name => 'User'
  
  def creator_name
    creator && creator.full_name
  end
  
  def grade_name 
    grade && grade.name
  end
  
  def created_on
    created_date && created_date.to_date
  end
end
