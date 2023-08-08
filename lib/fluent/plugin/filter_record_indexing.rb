require "fluent/filter"

module Fluent
  class RecordIndexingFilter < Filter
    Fluent::Plugin.register_filter("record_indexing", self)
    
    desc "Key name to spin"
    config_param :key_name, :string, default: nil
    config_param :key_prefix, :string, default: nil
    config_param :check_all_key, :bool, default: true
    
    def filter(tag, time, record)
      if check_all_key == false
        unless key_name
          raise ArgumentError, "key_name parameter is required if check_all_key set false"
        end
      end
      new_record = {}
      each_with_index(record, new_record)
      remove_empty_fields(new_record)
      new_record
    end

    def is_nested_field?(field_value)
      field_value.is_a?(Hash)
    end
  
    def each_with_index(record, new_record)
      record.each do |key, value|
        if check_all_key || key == key_name
          if value.nil?
            next  # Skip if the value is nil
          elsif value.is_a?(Array)
            new_record[key] = {}
            value.each_with_index do |item, index|
              new_record[key]["#{key_prefix}#{index}"] = item unless item.nil?
            end
          elsif is_nested_field?(value)
            new_record[key] = {}
            each_with_index(value, new_record[key])
          else
            new_record[key] = value
          end
        else
          new_record[key] = value
        end
      end
    end

    def remove_empty_fields(record)
      record.each do |key, value|
        if value.is_a?(Hash)
          remove_empty_fields(value)
        end
        record.delete(key) if (value.nil? || (value.respond_to?(:empty?) && value.empty?))
      end
    end
  end
end
