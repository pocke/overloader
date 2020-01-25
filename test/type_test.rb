require 'test_helper'

require 'overloader/type'

class TypeTest < Minitest::Test
  class C; end

  def test_callable_empty_method
    assert Overloader::Type.callable?('() -> String', C, :foo)
    refute Overloader::Type.callable?('() -> String', C, :foo, 1)
    refute Overloader::Type.callable?('() -> String', C, :foo, 1, 2, 3)
  end

  def test_callable_an_int
    refute Overloader::Type.callable?('(Integer) -> String', C, :foo)
    assert Overloader::Type.callable?('(Integer) -> String', C, :foo, 1)
    refute Overloader::Type.callable?('(Integer) -> String', C, :foo, 1, 2, 3)
    refute Overloader::Type.callable?('(Integer) -> String', C, :foo, '1')
  end
end
