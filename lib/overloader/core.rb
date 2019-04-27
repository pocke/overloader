module Overloader
  class Core
    using AstExt

    def self.define_overload(klass, proc)
      self.new(klass, proc).define_overload
    end

    def initialize(klass, proc)
      @klass = klass
      @proc = proc
    end

    def define_overload
      ast = RubyVM::AbstractSyntaxTree.of(@proc)
      methods = {}
      ast.find_nodes(:DEFN).each.with_index do |def_node, index|
        args = def_node.method_args
        body = def_node.method_body
        name = def_node.method_name
        args_source = args.to_source(absolute_path)
        args_source = "" if args_source == "(" # RubyVM::AST's bug?

        @klass.class_eval <<~RUBY
          def __#{name}_#{index}_checker_inner(#{args_source}) end
          def __#{name}_#{index}_checker(*args)
            __#{name}_#{index}_checker_inner(*args)
            true
          rescue ArgumentError
            false
          end
        RUBY

        @klass.class_eval <<~RUBY, absolute_path, def_node.first_lineno
          def __#{name}_#{index}(#{args_source})
          #{body.to_source(absolute_path)}
          end
        RUBY
        (methods[name] ||= []) << index
      end

      methods.each do |name, indexes|
        @klass.class_eval <<~RUBY
          def #{name}(*args, &block)
            #{indexes.map do |index|
              "return __#{name}_#{index}(*args, &block) if __#{name}_#{index}_checker(*args)"
            end.join("\n")}
            raise ArgumentError
          end
        RUBY
      end
    end

    private def absolute_path
      @proc.source_location[0]
    end
  end
end
