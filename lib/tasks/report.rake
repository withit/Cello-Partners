namespace :report do 
  desc "Deliver order report" 
  task :orders => :environment do
    Order.deliver_report
  end
  
  desc "Deliver quote report" 
  task :quotes => :environment do
    Quote.deliver_report
  end
  
  desc "Deliver both quotes and order reports" 
  task :all => [:orders, :quotes]
end