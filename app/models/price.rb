class Price < ActiveRecord::Base
  set_table_name 'pricing_data'
  
  def self.import_from_file file
    transaction do
      FasterCSV.foreach(file.path) do |row|
        create_from_row(row)
      end
    end
  end
  
  def self.create_from_row row
    row.each(&:strip!)
    row[4..8] = row[4..8].collect{|e| e.blank? ? nil : e}
    price = find_or_initialize_by_name_and_grade_and_grade_abbrev_and_subgrade_abbrev_and_calliper_and_gsm_and_break_and_price_and_price_type(*row)
    price.status = true
    price.date_uploaded = Time.now
    price.save
  end
  
  def ensure_price_line_exists
    PricingLine.find_by_name(name) || PricingLine.create(:name => name, :grade_abbrev => grade_abbrev, :status => 1, :date_uploaded => Time.now)
  end
  
  def ensure_product_grade_exists
    Grade.find_by_name(grade) || Grade.create(:name => grade, :grade_abbrev => grade_abbrev, :status => 1, :date_uploaded => Time.now)
  end
  
  after_create :ensure_price_line_exists, :ensure_product_grade_exists
  
  def self.prices_without_reels
    Price.all(:select => "grade, grade_abbrev, calliper, gsm") - Reel.find(:all,:select => "grade, grade_abbrev, calliper, gsm").collect{|e| e.becomes(Price)}
  end
  
  def paper
    Paper.new(grade, grade_abbrev, calliper, gsm)
  end
  
  def self.paper_without_reels
    (paper - Reel.paper).sort
  end
  
  def self.paper
    @paper ||= all.collect(&:paper).uniq
  end
  
  def price_type_label
    price_type && ["Fixed Price","Quantity"][price_type]
  end
  
  def uploaded_on
    date_uploaded.to_date
  end
end
