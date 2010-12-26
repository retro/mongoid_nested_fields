# encoding: utf-8

require 'mongoid'
require 'active_support/inflector'
require 'active_model/validations'
require 'yajl'

%w(nested_field_setter nested_field_holder nested_field_part nested_field_hash errors).each do |f|
  require "mongoid_nested_fields/#{f}"
end

Mongoid::Document.send(:include, MongoidNestedFields::NestedFieldSetter)

module MongoidNestedFields
  
end