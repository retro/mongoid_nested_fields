# encoding: utf-8

module MongoidNestedFields
  module NestedField
    module ClassMethods
      
      def nested_field(name, options = {})
        add_nested_field(name)
        set_validations
        options[:type] = Array
        set_allowed_types_in_field(name, options.delete(:allowed_types))
        define_method("#{name}=") do |value|
          raise TypeError unless [String, Array].include?(value.class)
          if value.is_a? String
            parser = Yajl::Parser.new
            value = parser.parse(value)
          end
          processed_values = []
          value.to_a.each do |v|
            v.stringify_keys!
            if(v.is_a?(Hash) && !v['_type'].nil?)
              v = v['_type'].classify.constantize.new(v)
              
            end
            raise MongoidNestedFields::Errors::UnexpectedType.new(v.class, name) unless self.class.is_allowed_type?(name, v.class)
            processed_values << v
          end
          write_attribute(name, processed_values)
        end
        
        define_method(name) do
          read_attribute(name).map{ |v| v.respond_to?(:to_mongo) ? v.to_mongo : v }
          
        end
        
        
      end
      
      def set_validations
        validate :nested_fields_must_be_valid
      end
      
      def set_allowed_types_in_field(field, type)
        field = field.to_sym
        @_allowed_types_in_field ||= {}
        @_allowed_types_in_field[field] ||= []
        @_allowed_types_in_field[field] << type
        @_allowed_types_in_field[field].flatten!.uniq!
      end
      def allowed_types_in_field(field)
        field = field.to_sym
        @_allowed_types_in_field ||= {}
        return @_allowed_types_in_field[field] || []
      end
      def is_allowed_type?(field, type)
        field = field.to_sym
        allowed_types_in_field(field).include?(type)
      end
      
      def field(name, options = {})
        add_field(name)
        
        define_method("#{name}=") do |value|
          klass = options[:type].nil? ? String : options.delete(:type).classify.constantize
          write_attribute(name, klass.new(value))
        end
        
        define_method(name) do
          read_attribute(name)
        end
        
      end
      
      def add_field(name)
        @_fields ||= []
        @_fields << name.to_sym
      end
      
      def add_nested_field(name)
        add_field(name)
        @_nested_fields ||= []
        @_nested_fields << name.to_sym
      end
      
    end
    
    
    
    def self.included(base)
      base.extend(ClassMethods)
      base.send(:include, ActiveModel::Validations)
    end
    
    def _type=(t)
    end
    
    def _type
      self.class.to_s.underscore
    end
    
    def initialize(attrs)
      attrs.each_pair do |k,v|
        if v.is_a?(Hash) && !v['_type'].nil?
          v = v['_type'].classify.constantize.new(v)
        end
        self.send("#{k}=", v)
      end
    end
    
    def write_attribute(name, value)
      @_attributes ||= {}
      @_attributes[name.to_sym] = value
    end
    
    def read_attribute(name)
      @_attributes ||= {}
      @_attributes[name.to_sym].respond_to?(:to_mongo) ? @_attributes[name.to_sym].to_mongo : @_attributes[name.to_sym]
    end
    
    def attributes
      @_attributes
    end
    
    def to_mongo
      attrs = MongoidNestedFields::NestedFieldHash.new
      attributes.each_key do |key|
        attrs[key.to_s] = self.send(key.to_sym)
      end
      attrs['_type'] = _type
      attrs.origin   = self
      attrs
    end
    
    def _nested_fields
      self.class.instance_variable_get(:@_nested_fields)
    end
    
    def nested_fields_must_be_valid
      _nested_fields.each do |field|
        value = read_attribute(field)
        i = 0
        field_errors = {}
        value.each do |v|
          if v.respond_to?(:invalid?) and v.invalid?
            field_errors[i.to_s] = v.errors
            i += 1
          end
        end if value.respond_to? :each
        errors.add(field, field_errors) unless field_errors.empty?
      end unless _nested_fields.nil?
    end
    
  end
end