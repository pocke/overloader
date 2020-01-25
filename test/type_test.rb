return if RUBY_VERSION < '2.7'

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

  def test_overload_with_type
    klass = Class.new do
      extend Overloader

      overload do
        # (String) -> Integer
        def to_i_or_to_s(str)
          str.to_i
        end

        # (Integer) -> String
        def to_i_or_to_s(int)
          int.to_s
        end
      end
    end

    i = klass.new
    assert_equal 10, i.to_i_or_to_s('10')
    assert_equal '10', i.to_i_or_to_s(10)
  end

  def test_overload_with_type2
    klass = Class.new do
      extend Overloader

      overload do
        def foo
          :no_arg
        end

        # (String) -> Symbol
        def foo(str)
          :one_str
        end

        # (Symbol) -> Symbol
        def foo(sym)
          :one_sym
        end

        # (Array[String]) -> Symbol
        def foo(arr)
          :str_arr
        end

        # (Array[Integer]) -> Symbol
        def foo(arr)
          :int_arr
        end

        # (Integer, String) -> Symbol
        def foo(a, b)
          :two_args
        end
      end
    end

    i = klass.new
    assert_equal :no_arg, i.foo
    assert_equal :one_str, i.foo('bar')
    assert_equal :one_sym, i.foo(:bar)
    assert_equal :str_arr, i.foo(['foo', 'bar'])
    assert_equal :int_arr, i.foo([42, 42])
    assert_equal :two_args, i.foo(1, '2')

    assert_raises(ArgumentError) { i.foo(nil) }
    assert_raises(ArgumentError) { i.foo([:x, :y]) }
    assert_raises(ArgumentError) { i.foo('2', 1) }
  end
end
