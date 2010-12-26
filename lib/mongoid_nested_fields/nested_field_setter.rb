# encoding: utf-8

module MongoidNestedFields
  module NestedFieldSetter
    module ClassMethods
      def nested_field(name, options = {})
        @_nested_fields ||= []
        @_nested_fields << name.to_s
        options[:type] = MongoidNestedFields::NestedFieldHolder
        
        _set_allowed_types_in_field(name, options.delete(:allowed_types))      
        _set_validations
        _set_serialization

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
            raise MongoidNestedFields::Errors::UnexpectedType.new(v.class, name) unless self.class._is_allowed_type?(name, v.class)
            processed_values << v
          end
          write_attribute(name, processed_values)
        end
        
      end
      
      def _set_serialization
        before_save :_serialize_nested_fields
        after_save  :_restore_nested_fields
      end
    
      def _set_validations
        validate :_nested_fields_must_be_valid
      end
    
      def _set_allowed_types_in_field(field, type)
        field = field.to_sym
        @_allowed_types_in_field ||= {}
        @_allowed_types_in_field[field] ||= []
        @_allowed_types_in_field[field] << type
        @_allowed_types_in_field[field].flatten!
        @_allowed_types_in_field[field].uniq! unless @_allowed_types_in_field[field].nil?
      end
      def _allowed_types_in_field(field)
        field = field.to_sym
        @_allowed_types_in_field ||= {}
        return @_allowed_types_in_field[field] || []
      end
      def _is_allowed_type?(field, type)
        field = field.to_sym
        _allowed_types_in_field(field).include?(type)
      end
    end
    
    def self.included(reciever)
      reciever::ClassMethods.send :include, ClassMethods
    end
    
    private
    
      def _nested_fields
        self.class.instance_variable_get(:@_nested_fields)
      end
    
      def _serialize_nested_fields
        _nested_fields.each do |nested_field|
          serialized_nested_field = []
          value = read_attribute(nested_field)
          value.each do |part|
            serialized_nested_field << (part.respond_to?(:to_mongo) ? part.to_mongo : part)
          end unless value.nil?
          write_attribute(nested_field, serialized_nested_field)
        end
      end
    
      def _restore_nested_fields
        _nested_fields.each do |nested_field|
          restored_nested_field = []
          value = read_attribute(nested_field)
          value.each do |part|
            restored_nested_field << (part.respond_to?(:origin) ? part.origin : part)
          end unless value.nil?
          write_attribute(nested_field, restored_nested_field)
        end
      end
    
      def _nested_fields_must_be_valid
      
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