require "fluent/filter"

module Fluent
  class RecordIndexingFilter < Filter
    Fluent::Plugin.register_filter("record_indexing", self)

    desc "Key names to spin"
    config_param :key_names, :array, default: []
    config_param :key_prefix, :string, default: nil
    config_param :check_all_key, :bool, default: true
    config_param :ignore_length, :bool, default: true
    config_param :exclude_keys, :array, default: []

    def filter(tag, time, record)
      if !@check_all_key && key_names.empty?
        raise ArgumentError, "key_names parameter is required if check_all_key set false"
      end
      new_record = {}
      each_with_index(record, new_record)
      remove_empty_fields(new_record)
      new_record
    end

    def each_with_index(record, new_record)
      seen_keys = {}  # To keep track of duplicate names
      record.each do |key, value|
        if @check_all_key || @key_names.include?(key)
          if @exclude_keys.include?(key)
            new_record[key] = value  # Keep the value as is without indexing
          elsif value.is_a?(Array)
            if !@ignore_length && value.length == 1
              new_record[key] = value.first
            else
              new_record[key] = {}
              value.each_with_index do |item, index|
                if item.is_a?(Hash) && item.key?("name") && item.key?("value")
                  item_name = item["name"]
                  if seen_keys[item_name]
                    new_record[key]["#{@key_prefix}#{index}"] = item
                  else
                    new_record[key][item_name] = item["value"]
                    seen_keys[item_name] = true
                  end
                else
                  new_record[key]["#{@key_prefix}#{index}"] = item
                end
              end
            end
          elsif value.is_a?(Hash)
            new_record[key] = {}
            each_with_index(value, new_record[key])
          else
            new_record[key] = value
          end
        elsif value.is_a?(Hash)  # Check if the value is a nested Hash
          new_record[key] = {}
          each_with_index(value, new_record[key])  # Recursively index nested fields
        else
          new_record[key] = value
        end
      end
      new_record
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
