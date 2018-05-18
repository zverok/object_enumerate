require 'test/unit'
require_relative '../lib/object_enumerate'

class TestEnumerate < Test::Unit::TestCase
  def test_enumerate
    enum = 1.enumerate(&:succ)
    assert_instance_of(Enumerator, enum)
    assert_equal(nil, enum.size)
    assert_equal([1, 2, 3, 4], enum.take(4))
    assert_raise(ArgumentError) { 1.enumerate }
  end
end
