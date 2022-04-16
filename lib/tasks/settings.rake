namespace :settings do
  desc "Load initial settings"
  task :load => :environment do
    Setting.find_by_Label('max_length') || Setting.create!(:Label => "max_length", :Value => 2015)
    Setting.find_by_Label('max_length_without_surcharge') || Setting.create!(:Label => "max_length_without_surcharge", :Value => 1600)
    Setting.find_by_Label('surcharge_per_kilo') || Setting.create!(:Label => "surcharge_per_kilo", :Value => 0.0)
    Setting.find_by_Label('minimum_surcharge') || Setting.create!(:Label => "minimum_surcharge", :Value => 250)
    Setting.find_by_Label('max_width_with_surcharge') || Setting.create!(:Label => "max_width_with_surcharge", :Value => 1360)

    Setting.find_by_Label('smtp_relay_address') || Setting.create!(:Label => "smtp_relay_address", :Value => "smtp.gmail.com")
    Setting.find_by_Label('smtp_relay_port') || Setting.create!(:Label => "smtp_relay_port", :Value => "587")
    Setting.find_by_Label('smtp_relay_domain') || Setting.create!(:Label => "smtp_relay_domain", :Value => "imo.com.au")
    Setting.find_by_Label('smtp_relay_user_name') || Setting.create!(:Label => "smtp_relay_user_name", :Value => "jason@imo.com.au")
    Setting.find_by_Label('smtp_relay_password') || Setting.create!(:Label => "smtp_relay_password", :Value => "")
    Setting.find_by_Label('smtp_relay_enable_starttls_auto') || Setting.create!(:Label => "smtp_relay_enable_starttls_auto", :Value => "true")
    Setting.find_by_Label('smtp_relay_logger') || Setting.create!(:Label => "smtp_relay_logger", :Value => "nil")

    Setting.find_by_Label('smtp_sender_address') || Setting.create!(:Label => "smtp_sender_address", :Value => "partners@cello.com.au")
    Setting.find_by_Label('smtp_quote_cc_address') || Setting.create!(:Label => "smtp_quote_cc_address", :Value => "sales@cello.com.au")

    Setting.find_by_Label('smtp_prod_reports_mailto') || Setting.create!(:Label => "smtp_prod_reports_mailto", :Value => "board.stock.group@cello.com.au")
    Setting.find_by_Label('smtp_prod_out_of_stock_alert_mailto') || Setting.create!(:Label => "smtp_prod_out_of_stock_alert_mailto", :Value => "sales@cello.com.au")

  end
end
