class Quote < ActiveRecord::Base
  set_table_name 'orders'
  set_inheritance_column 'foo'
  
  belongs_to :organisation, :foreign_key => 'org_id'
  belongs_to :grade
  
  def organisation_name
    organisation.name
  end
  
  def initialize attributes={}, *args
    super
    self.created_date ||= Date.today
    self.type ||= 'Quote'
    self.status ||= 0
  end

  def calliper_options
    return [] unless grade
    grade.callipers
  end
  
  def grade
    Grade.find_by_grade_abbrev(grade_abbrev)
  end
  
  def gross_weight
    find_reel && (find_reel.weight_per_unit_length(width) * length * sheets) / 10**9
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
    p = prices.break_less_than(gross_weight).first(:order => "break desc", :select => 'price')
    p && p.price
  end
  
  def price_per_1000_sheets
    find_rate && find_rate * gross_weight * 1000 / sheets
  end
  
  def set_price
    self.price = price_per_1000_sheets
  end
  
  def set_rate
    self.rate = find_rate
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
  
  def created_at
    created_date && created_date.to_time
  end
  
  def set_calculations
    set_reel
    set_price
    set_reel
    set_kilos
    set_rate
    set_surcharge
  end
  
  def set_surcharge
    self.setup_surcharge = 500 * [sheets.to_f / 1000, 1].min if length && length > 1600
  end
  
  before_create :set_calculations, :set_creator
  
  belongs_to :parent, :class_name => 'Quote', :foreign_key => 'parent_id'
  has_many :clones, :class_name => 'Quote', :foreign_key => 'parent_id', :before_add => :clone_attributes_from_parent
  
  def set_updated_at
    self.updated_date = Time.now
  end
  
  before_save :set_updated_at
  
  def clone_attributes_from_parent child
    child.attributes = self.attributes
  end
  
  def set_creator
    self.creator ||= UserSession.find && UserSession.find.user
  end
  
  attr_accessor :email

  def emailed?
    @email_sent
  end
  
  def deliver_as_email
    @email_sent = true
    Notifier.deliver_quote(self)
  end
end
