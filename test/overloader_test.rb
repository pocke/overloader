require 'test_helper'

class OverloaderTest < Minitest::Test
  def test_overload
    klass = Class.new do
      extend Overloader

      overload do
        def x
          :x1
        end

        def x(a)
          :x2
        end

        def x(a, b)
          :x3
        end
      end
    end

    i = klass.new
    assert_equal :x1, i.x
    assert_equal :x2, i.x(1)
    assert_equal :x3, i.x(1, 2)
  end

  def test_overload_2_methods
    klass = Class.new do
      extend Overloader

      overload do
        def x
          :x1
        end

        def x(a)
          :x2
        end

        def y(a)
          :y1
        end

        def y(a, b)
          :y2
        end
      end
    end

    i = klass.new
    assert_equal :x1, i.x
    assert_equal :x2, i.x(1)
    assert_equal :y1, i.y(1)
    assert_equal :y2, i.y(1, 2)
  end
end
