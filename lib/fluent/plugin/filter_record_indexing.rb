require "fluent/filter"

module Fluent
    class RecordIndexingFilter < Filter
      Fluent::Plugin.register_filter("record_indexing", self)

      desc "Key name to spin"
      config_param :key_name, :string, default: nil
      config_param :key_prefix, :string, default: nil
      config_param :check_all, :bool, default: true

      def transform(tag,record)
        unless key_name
          raise ArgumentError, "key_name parameter is required"
        end
        new_record = {}
        record.each do |key, value|
          if check_all || (key == key_name && value.is_a?(Array))
            new_record[key] = {}
            value.each_with_index do |item, index|
              new_record[key]["#{key_prefix}#{index}"] = item
            end
          else
            new_record[key] = value
          end
        end
        new_record
      end
    end
  end
end
