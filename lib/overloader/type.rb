gem 'ruby-signature'
require 'ruby/signature'
require 'ruby/signature/test'

require_relative 'type/checker'

module Overloader
  module Type
    CHECKERS = {}
    extend self

    ruby2_keywords def callable?(type, klass, method_name, *args)
      checker = checker(klass: klass, type: type)
      checker.errors(method_name, *args).empty?
    end

    private def checker(klass:, type:)
      CHECKERS[[klass, type]] ||= Checker.new(type: type, klass: klass)
    end
  end
end
