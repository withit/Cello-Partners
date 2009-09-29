require 'test_helper'

class ReelTest < ActiveSupport::TestCase
  
  should "have try and fit as many pages as possible along the width of the real" do
    reel = Factory(:reel, :reel_size => 1000)
    assert_equal 0, reel.pages_per_unit_length(1010)
    assert_equal 1, reel.pages_per_unit_length(1000)
    assert_equal 1, reel.pages_per_unit_length(900)
    assert_equal 2, reel.pages_per_unit_length(480)
  end
  
  should "something to so with weight" do
    reel = Factory(:reel, :reel_size => 1000, :gsm => 200)
    assert_equal 100, reel.weight_per_unit_length(500)
    assert_equal 200, reel.weight_per_unit_length(501)
  end
  
  
  # def pages_per_unit_length page_width
  #   real_size / page_width 
  # end
  # 
  # def weight_per_unit_length page_width
  #   reel_size / pages_per_unit_length(page_width)
  # end
end
