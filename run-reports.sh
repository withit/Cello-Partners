#!/bin/bash

#
# Try to setup the path correctly
PATH=/Users/itadmin/.rvm/gems/ruby-1.9.3-p547@rails23/bin:/Users/itadmin/.rvm/gems/ruby-1.9.3-p547@global/bin:/Users/itadmin/.rvm/rubies/ruby-1.9.3-p547/bin:/Users/itadmin/.rvm/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin

export PATH

# Required for the MySql gem libraries
export DYLD_LIBRARY_PATH=/usr/local/mysql/lib:$DYLD_LIBRARY_PATH


#
# RVM INtegration from https://rvm.io/integration/cron

#
# Get environment setup
source /Users/itadmin/.rvm/environments/ruby-1.9.3-p547@rails23

#
# Only production
# (commented out for now, because I want it to run in test & development)
# export RAILS_ENV=production

#
# Get out the reports
rake report:all
