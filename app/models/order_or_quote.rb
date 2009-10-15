class OrderOrQuote < ActiveRecord::Base
  set_table_name 'orders'
  
  def self.compute_type type_name
    super type_name == "0" ? "Quote" : type_name
  end
  
  def grain 
    return unless width && length
    width > length ? "Short" : "Long"
  end
  
  attr_accessor :email
  
  before_create :set_creator
  def set_creator
    self.creator ||= UserSession.find && UserSession.find.user
  end
  
  def set_updated_at
    self.updated_date = Time.now
  end
  
  before_save :set_updated_at
  
  belongs_to :parent, :class_name => 'Quote', :foreign_key => 'parent_id'
  
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
  
  belongs_to :organisation, :foreign_key => 'org_id'
  
  def organisation_name
    organisation && organisation.name
  end
  
  belongs_to :grade
  def grade
    Grade.find_by_grade_abbrev(grade_abbrev)
  end
  
  def price_per_1000_sheets_including_surcharge
    return unless price && sheets && sheets > 0
    price + setup_surcharge.to_f / sheets.to_f * 1000
  end
  
  def size
    "#{width} mm x #{length} mm (w x l)"
  end
  
  def total_price
    price * 1000 + setup_surcharge.to_i
  end
  
  def self.report
    find(:all, :include => [:creator, {:organisation => :rep}], :conditions => ["updated_date > ?", Date.yesterday])
  end
  
  def rep_name
    organisation && organisation.rep_name
  end
end
