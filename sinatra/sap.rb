require 'rubygems'
require 'sinatra'
#require 'ruby-odbc-0.9997/odbc'
require 'active_record'

ActiveRecord::Base.establish_connection(
  #:adapter => "jdbc",
  #:driver => "com.microsoft.sqlserver.jdbc.SQLServerDriver",
  #:url => "jdbc:sqlserver://fermat.wi.com.au:1433;databaseName=cello_sap;",
  :username => "sa",
  :password => "dg90p",
  :adapter  => "odbc",
  :dsn      => "cello_sap"
)

class Stock < ActiveRecord::Base
  set_table_name "OITW"
  
  def self.find_by_item_code! code
    find(:first, :conditions => {:ItemCode => code}) || raise(Sinatra::NotFound)
  end
end

get '/stocks/:id.json' do
  Stock.find_by_item_code!(params[:id]).to_json
end