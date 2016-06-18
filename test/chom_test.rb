require 'test_helper'

class ChomTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Chom::VERSION
  end

  def test_it_can_be_created
    assert_equal true, Chom::App.new.instance_of?(Chom)
  end
end
