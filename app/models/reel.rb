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
    gsm * reel_size/ pages_per_unit_length(page_width)
  end
  
  def self.load_from_file(file)
    count = 0
    FasterCSV.foreach(file.path) do |row|
      create_from_row(row)
      count += 1
    end
    count
  end
  
  def self.create_from_row row
    row.each(&:strip!)
    row[3..5] = row[3..5].collect{|e| e.blank? ? nil : e}
    reel = find_or_initialize_by_grade_and_grade_abbrev_and_subgrade_abbrev_and_calliper_and_gsm_and_reel_size(*row[0..5])
    reel.sap_code = row[6]
    reel.sap_alt_code_1 = row[7]
    reel.sap_alt_code_2 = row[8]
    reel.save
  end
  
  def set_uploaded_timestamp
    self.date_uploaded = Time.now
  end
  
  before_save :set_uploaded_timestamp
  
  before_create :increment_create_counter
  before_update :increment_update_counter
  
  def self.updated_counter
    @updated_counter ||= 0
  end
  
  def self.created_counter
    @created_counter ||= 0
  end
  
  def increment_create_counter
    self.class.increment_create_counter
  end
  
  def increment_update_counter
    self.class.increment_update_counter
  end
  
  def self.increment_create_counter
    @created_counter ||= 0
    @created_counter += 1
  end
  
  def self.increment_update_counter
    @updated_counter ||= 0
    @updated_counter += 1
  end
  
  def self.paper
    @paper ||= all.collect(&:paper).uniq
  end
  
  def paper
    Paper.new(grade, grade_abbrev, calliper, gsm)
  end
  
  def self.paper_without_prices
    (paper - Price.paper).sort
  end
  
  def best_width_under width
    return unless reel_size
    return width if reel_size.multiple_of?(width)
    times_fits_in = reel_size / width
    desired_times_fits_in =  times_fits_in + 1
    reel_size / desired_times_fits_in
  end
  
  def uploaded_on
    date_uploaded && date_uploaded.to_date
  end
  
  def available
    @avaiable ||= stocks.sum{|s| s.available}
  end
  
  def status weight
    return unless primary_stock
    if weight > available
      :not_available
    elsif (available - weight) < primary_stock.MinStock
      :limited
    else
      :available
    end
  end
  
  def stocks
    [primary_stock, alt_stock_1, alt_stock_2].compact
  end
  
  def primary_stock
    @primary_stock ||= Stock.find(sap_code) unless sap_code.blank?
  rescue ActiveResource::ResourceNotFound
    nil
  end
  
  def alt_stock_1
    Stock.find(sap_alt_code_1) unless sap_alt_code_1.blank?
  rescue ActiveResource::ResourceNotFound
    nil
  end
  
  def alt_stock_2
    Stock.find(sap_alt_code_2) unless sap_alt_code_2.blank?
  rescue ActiveResource::ResourceNotFound
    nil
  end
  
end
