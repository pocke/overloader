module Overloader
  module AstExt
    refine RubyVM::AbstractSyntaxTree::Node do
      def traverse(&block)
        block.call(self)
        children.each do |child|
          child.traverse(&block) if child.is_a?(RubyVM::AbstractSyntaxTree::Node)
        end
      end

      def find_nodes(*types)
        nodes = []
        traverse do |node|
          nodes << node if types.include?(node.type)
        end
        nodes
      end

      def to_source(path)
        file_content(path)[first_index(path)..last_index(path)]
      end

      def comment(content: nil, path: nil)
        raise ArgumentError.new("content or path is required") unless content || path

        content ||= file_content(path)
        l = first_lineno - 2

        res = []
        while (comment = content.lines[l])&.match?(/^\s*#/)
          res.unshift comment
          l -= 1
        end
        res.empty? ? nil : res.join
      end

      # method node ext

      def method_body
        children[1].children[2]
      end

      def method_args
        children[1].children[1]
      end

      def method_name
        children[0]
      end

      private def first_index(path)
        return first_column if first_lineno == 1

        lines = file_content(path).split("\n")
        lines[0..(first_lineno - 2)].sum(&:size) +
          first_lineno - 1 + # For \n
          first_column
      end

      private def last_index(path)
        last_column = self.last_column - 1
        return last_column if last_lineno == 1

        lines = file_content(path).split("\n")
        lines[0..(last_lineno - 2)].sum(&:size) +
          last_lineno - 1 + # For \n
          last_column
      end

      private def file_content(path)
        @file_content ||= {}
        @file_content[path] ||= File.binread(path)
      end
    end
  end
end
