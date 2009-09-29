require 'test_helper'

class OrganisationTest < ActiveSupport::TestCase
  should_have_many :users
  should_have_many :quotes
end
