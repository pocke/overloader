require "overloader/version"
require 'overloader/ast_ext'
require 'overloader/core'

module Overloader
  def overload(&block)
    Core.define_overload(self, block)
  end
end
