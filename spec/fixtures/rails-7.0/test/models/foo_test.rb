# magic_ball.rb
require 'minitest/autorun'
require 'test_helper'

class FooTest < Minitest::Test
  def test_factory
    assert_equal FactoryBot.create(:foo, name: 'bar').name, 'bar'
  end
end