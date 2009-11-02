begin 
  require 'odbc'
rescue LoadError
  require 'sinatra/ruby-odbc-0.9997/odbc'
end