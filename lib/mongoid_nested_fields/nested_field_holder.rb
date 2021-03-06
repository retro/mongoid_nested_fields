# encoding: utf-8

module MongoidNestedFields
  class NestedFieldHolder
    def self.get(value)
      if value.is_a? Array
        value = value.map do |v|
          if((v.is_a?(Hash) or v.is_a?(BSON::OrderedHash)) and !v['_type'].nil?)
            v = v['_type'].classify.constantize.new(v.to_hash)
          end
          v
        end
      end
      value
    end
    
    def self.set(value)
      value
    end
    
  end
end