class ObjectPresenter < Presenter
  required_keys :object, :ctx  # ctx is the view context

  @@splited_objects = [:user]

  def object_ref
    object.class.name.underscore.to_sym
  end

  def controller_ref
    object_ref.to_s.pluralize
  end

  def layout_partial
    layout = (@@splited_objects.include? object_ref) ? 'splitted' : 'regular'
    "shared/object_content/#{layout}"
  end

  def header_partial
    @header || "#{controller_ref}/header"
  end

  def content_partial
    @content || "#{controller_ref}/content"
  end

  def side_pane_partial
    @side_pane || "#{controller_ref}/side_pane"
  end

  def object_params(hash={})
    {object_ref => object}.merge hash
  end

  def hide_location?
    try(:show_location) == false
  end
end
