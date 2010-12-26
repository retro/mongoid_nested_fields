# encoding: utf-8

module MongoidNestedFields
  module NestedFieldSetter
    module ClassMethods
      def nested_field(name, options = {})
        @_nested_fields ||= []
        @_nested_fields << name.to_s
        options[:type] = MongoidNestedFields::NestedFieldHolder
        
        set_allowed_types_in_field(name, options.delete(:allowed_types))      
        set_validations

        field(name, options)
        meth = options.delete(:as) || name
        define_method("#{meth}=") do |value|
          raise TypeError unless [String, Array, NilClass].include?(value.class)
          if value.is_a? String
            parser = Yajl::Parser.new
            value = parser.parse(value)
          end
          processed_values = []
          value.to_a.each do |v|
            v.stringify_keys! if v.is_a? Hash
            if((v.is_a?(Hash) or v.is_a?(BSON::OrderedHash)) and !v['_type'].nil?)
              v = v['_type'].classify.constantize.new(v.to_hash)
            end
            raise MongoidNestedFields::Errors::UnexpectedType.new(v.class, name) unless self.class.is_allowed_type?(name, v.class)
            processed_values << v
          end
          write_attribute(name, processed_values)
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
    end
    
    def self.included(reciever)
      reciever::ClassMethods.send :include, ClassMethods
    end
    
    def _nested_fields
      self.class.instance_variable_get(:@_nested_fields)
    end
    
    def rebuild_nested_fields
      _nested_fields.each do |c|
        value = self.send(c)
        self.send("#{c}=", value) unless value.nil?
      end
    end
    
    def nested_fields_must_be_valid
      
      _nested_fields.each do |field|
        value = read_attribute(field)
        i = 0
        field_errors = {}
        value.each do |v|
          if v.respond_to?(:origin) and v.origin.respond_to?(:invalid?) and v.origin.invalid?
            field_errors[i.to_s] = v.origin.errors
            i += 1
          end
        end if value.respond_to? :each
        errors.add(field, field_errors) unless field_errors.empty?
      end unless _nested_fields.nil?
    end
    
  end
end