module CSVGenerator
  module_function

  def generate(hash_collection)
    return "" if hash_collection.empty?

    columns = hash_collection[0].keys
    CSV.generate do |csv|
      csv << columns
      hash_collection.each { |hash| csv << hash.values_at(*columns).map { |v| csv_value v } }
    end
  end

  def csv_value(v)
    v.is_a?(Hash) || v.is_a?(Array) ? v.to_json : v
  end
end
