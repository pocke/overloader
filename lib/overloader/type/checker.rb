module Overloader
  module Type
    class Checker
      def initialize(type:, klass:)
        @type = type
        @klass = klass
      end

      def self.env
        @env ||= begin
                   loader = Ruby::Signature::EnvironmentLoader.new
                   Ruby::Signature::Environment.new.tap do |env|
                     loader.load(env: env)
                   end
                 end
      end

      def self.builder
        Ruby::Signature::DefinitionBuilder.new(env: env)
      end

      ruby2_keywords def errors(method_name, *args)
        call = Ruby::Signature::Test::CallTrace.new(
          method_call: Ruby::Signature::Test::ArgumentsReturn.new(arguments: args, return_value: nil, exception: nil),
          block_calls: [],
          block_given: false,
        )
        errors = type_check.method_call(method_name, method_type, call, errors: [])

        errors.reject { |e| e.is_a?(Ruby::Signature::Test::Errors::ReturnTypeError) }
      end

      private def method_type
        Ruby::Signature::Parser.parse_method_type(type)
      end

      private def type_check
        Ruby::Signature::Test::TypeCheck.new(self_class: klass, builder: self.class.builder)
      end


      private
      attr_reader :type, :klass
    end
  end
end
