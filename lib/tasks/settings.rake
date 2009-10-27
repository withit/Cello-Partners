namespace :settings do
  desc "Load initial settings" 
  task :load => :environment do
    Setting.find_by_Label('max_length') || Setting.create!(:Label => "max_length", :Value => 2015)
    Setting.find_by_Label('max_length_without_surcharge') || Setting.create!(:Label => "max_length_without_surcharge", :Value => 1600)
    Setting.find_by_Label('surcharge_per_kilo') || Setting.create!(:Label => "surcharge_per_kilo", :Value => 0.0)
    Setting.find_by_Label('minimum_surcharge') || Setting.create!(:Label => "minimum_surcharge", :Value => 250)
    Setting.find_by_Label('max_width_with_surcharge') || Setting.create!(:Label => "max_width_with_surcharge", :Value => 1360)
  end
end
