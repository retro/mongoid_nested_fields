# encoding: utf-8

module MongoidNestedFields
  module Errors
    class UnexpectedType < TypeError
      def initialize(type, field)
        super("Unexpected type #{type} in field #{field}")
      end
    end
  end
end