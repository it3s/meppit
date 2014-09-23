class ParsedDataPresenter
  include Presenter

  required_keys :data, :index, :ctx

  def object
    @object ||= GeoData.new data
  end

  def valid?
    @is_valid ||= object.valid?
  end

  def valid_class
    valid? ? 'valid' : 'invalid'
  end

  def jsontable_options
    {jsonData: data}.to_json
  end

  def jsontable_id
    "json_table_#{ index }"
  end

end
