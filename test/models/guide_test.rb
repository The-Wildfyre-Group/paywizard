require 'test_helper'

class GuideTest < ActiveSupport::TestCase
  
  def setup
    @name = "Neocate Junior", @state = "California", @payer = "Aetna"
    @guide = Guide.new(name: @name, state: @state, payer: @payer)
  end
  
  test "payer name should be present" do
    @guide.name = ""
    assert_not @guide.valid?, "Product Name should not be blank."
  end
  
  test "state should be present" do
    @guide.state = ""
    assert_not @guide.valid?, "State should not be blank."
  end
  
  test "payer should be present" do
    @guide.payer = ""
    assert_not @guide.valid?, "Payer should not be blank."
  end
  
end

