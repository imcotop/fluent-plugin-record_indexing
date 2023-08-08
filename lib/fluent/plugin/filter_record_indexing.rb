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
          raise ArgumentError, "key_name parameter is required"
        end
      end
      new_record = {}
      record.each do |key, value|
        if check_all_key || key == key_name
          new_record[key] = {}
          if value.is_a?(Array)
            value.each_with_index do |item, index|
              new_record[key]["#{key_prefix}#{index}"] = item
            end
          else
            new_record[key] = value
          end
        else
          new_record[key] = value
        end
      end
      new_record
    end
  end
end
