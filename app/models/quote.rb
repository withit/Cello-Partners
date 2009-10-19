class Quote < OrderOrQuote
  
  def initialize attributes={}, *args
    super
    self.created_date ||= Date.today
    self.status ||= 0
  end
  
  attr_accessor :standard

  def calliper_options
    return [] unless grade
    grade.callipers
  end
  
  def grade_options
    organisation.grades
  end
  
  def gross_weight
    find_reel && (find_reel.weight_per_unit_length(width) * length * sheets).to_f / 10**9
  end
  
  def set_kilos
    self.kilos = gross_weight
  end
  
  def ex_reels
    reel
  end
  
  def find_reel
    reels.to_a.min do |a,b|
      a.weight_per_unit_length(width) <=> b.weight_per_unit_length(width)
    end
  end
  
  def set_reel
    reel = find_reel
    self.reel = reel && reel.reel_size
    self.gsm = reel && reel.gsm
  end
  
  def reels
    return unless grade_abbrev && calliper
    Reel.reel_size_greater_than(width).find_all_by_grade_abbrev_and_calliper(grade_abbrev, calliper)
  end
  
  def prices    
    Price.scoped(:conditions => {:status => true, :grade_abbrev => grade_abbrev, :calliper => calliper, :name => organisation.price_names})
  end
  
  def find_rate
    p = prices.break_less_than_or_equal_to(gross_weight).first(:order => "break desc", :select => 'price')
    p && p.price
  end
  
  def recommendation_for_width
    recommended_reel = Reel.find_all_by_grade_abbrev_and_calliper(grade_abbrev, calliper).to_a.max do |a,b|
      a.best_width_under(width) <=> b.best_width_under(width)
    end
    return unless recommended_reel
    recommended_width = recommended_reel.best_width_under(width)
    recommended_width == width ? nil : recommended_width
  end
  
  def recomendation_for_sheets
    return unless recommeded_weight 
    (recommeded_weight.to_f / find_reel.weight_per_unit_length(width) / length * 10**9).ceil
  end
  
  def find_recommeded_weight
    recommened_break_point = prices.break_greater_than(gross_weight).first(:order => "break asc") || return
    recommened_break_point.break
  end
  
  def recommeded_weight
    @recommeded_weight ||= find_recommeded_weight
  end
  
  def rounded_recomendation_for_sheets
    return unless recomendation_for_sheets
    (recomendation_for_sheets % 100).zero? ? recomendation_for_sheets : recomendation_for_sheets - (recomendation_for_sheets % 100) + 100
  end
  
  def price_per_1000_sheets
    find_rate && find_rate * gross_weight * 1000 / sheets
  end
  
  def set_price
    if price_per_1000_sheets && (price_per_1000_sheets * sheets / 1000) < 250
      self.price = 250.to_f / sheets * 1000
    else
      self.price = price_per_1000_sheets
    end
  end
  
  def set_rate
    self.rate = find_rate
  end
  
  def set_calculations
    set_reel
    set_price unless standard == false
    set_reel
    set_kilos
    set_rate unless standard == false
    set_surcharge unless standard == false
  end
  
  def set_surcharge
    if length && length > Setting.max_length_without_surcharge.to_i
      self.setup_surcharge = [Setting.minimum_surcharge.to_i, Setting.surcharge_per_kilo.to_f * kilos.to_f].max 
    else
      self.setup_surcharge = 0
    end
  end
  
  before_create :set_calculations
  
  has_many :clones, :class_name => 'Quote', :foreign_key => 'parent_id', :before_add => :clone_attributes_from_parent
  
  def clone_attributes_from_parent child
    child.attributes = self.attributes_before_type_cast.reject{|k,v| v.blank?}
  end
  
  def emailed?
    @email_sent
  end
  
  def deliver_as_email
    @email_sent = true
    Notifier.deliver_quote(self)
  end
  
  validates_numericality_of :length, :width
  validates_numericality_of :length, :width, :greater_than_or_equal_to => 300, :message => "must be at least 300mm"
  validate :ensure_that_there_is_a_reel_width_enough
  #validates_numericality_of :length,:less_than_or_equal_to => lambda{Setting.max_length.to_i}, :message => "can't be more than 2015mm"
  
  def ensure_less_than_max_length
    errors.add(:length, "can't be more than #{Setting.max_length}mm") if length.to_i > Setting.max_length.to_i
  end
  
  validate :ensure_less_than_max_length
  
  def ensure_that_there_is_a_reel_width_enough
    errors.add(:width, 'there is no reel wide enough') unless find_reel
  end
  
  def can_be_saved?
    parent && errors.empty?
  end
  
  has_many :orders, :foreign_key => 'parent_id', :before_add => :clone_attributes_from_parent

  def recommendations
    @recommedations ||= [recommendation_for_width, rounded_recomendation_for_sheets].compact
    @recommedations.empty? ? nil : @recommedations
  end  
  
  def self.deliver_report
    Notifier.deliver_quote_report(report)
  end
  
  def stock_availability
    :not_available
  end
end
