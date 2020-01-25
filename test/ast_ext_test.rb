require 'test_helper'

class AstExtTest < Minitest::Test
  using Overloader::AstExt

  def test_comment_nil
    code = <<~RUBY.b
      def foo
      end
    RUBY
    ast = parse(code)
    defn = ast.children.last
    assert_equal :DEFN, defn.type
    assert_nil defn.comment(content: code)
  end

  def test_comment_exist
    code = <<~RUBY.b
      # This is foo
      def foo
      end
    RUBY
    ast = parse(code)
    defn = ast.children.last
    assert_equal :DEFN, defn.type
    assert_equal "# This is foo\n", defn.comment(content: code)
  end

  def test_comment_multiline
    code = <<~RUBY.b
      # This is foo
      # foobar
      def foo
      end
    RUBY
    ast = parse(code)
    defn = ast.children.last
    assert_equal :DEFN, defn.type
    assert_equal "# This is foo\n# foobar\n", defn.comment(content: code)
  end

  private def parse(code)
    RubyVM::AbstractSyntaxTree.parse(code)
  end
end
