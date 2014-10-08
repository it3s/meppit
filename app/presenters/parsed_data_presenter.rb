class ParsedDataPresenter
  include Presenter

  required_keys :parsed, :index, :ctx

  def data
    @data ||= parsed.data
  end

  def row
    @row ||= parsed.row
  end

  def object
    @valid_additional_info = (data[:additional_info].nil? || data[:additional_info].is_a?(Hash))
    @object ||= begin
      GeoData.new data
    rescue
      GeoData.new data.merge(additional_info: nil)
    end
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

  def data_preview_id
    "data-preview-#{ index }"
  end

  def errors
    object.errors.add(:additional_info, ctx.t('additional_info.invalid')) unless @valid_additional_info
    errs = object.errors.messages.map do |k, v|
      "<span class=\"err-key\">#{k}:</span> #{v.first}"
    end
    errs.join(" | ").html_safe
  end

  def number
    "##{index + 1}"
  end

end
