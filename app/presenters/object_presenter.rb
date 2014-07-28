# Used with the "shared/object" partial
#
# == Rendering partials:
#
#   Tries to get a variable with same name of the partial, if you dont pass any
#   it will use the following convention: <controller_ref>/<partial>
#   Example:
#
#     ObjectPresenter.new object: @map
#     >>>  header_partial => "maps/header"
#     >>>  content_partial => "maps/content"
#
#     ObjectPresenter.new object: @map, content: "specific_partial"
#     >>>  header_partial => "maps/header"
#     >>>  content_partial => "specific_partial"
#
# == Chosing layout:
#
#   By default use the `shared/object_content/regular` layout. For using a
#   splitted layout (like in users), just add the object_ref to the
#   `@@splited_objects` array
#
# == Displaying location:
#
#   By default always show the location. If you want to hide, pass the argument:
#   `show_location: false`.
#
# == Displaying the toolbar:
#
#   By default always show the toolbar. If you want to hide, pass the argument:
#   `show_toolbar: false`.
#
# == Styling
#
#   The `.site-page` wrapper will always have two css classes, one after the
#   object controller and other for the action, e. g., if `object` is a `Map`
#   instance, and the action is `edit` => `div.site-page.maps.edit`
#
class ObjectPresenter
  include Presenter

  required_keys :object

  # Reference for the models which use a splitted layout
  @@splited_objects = [:user]

  # reference for the object's model. Ex:
  #   Map instance => :map, GeoData instance => :geo_data
  def object_ref
    object.class.name.underscore.to_sym
  end

  # reference for the object's controller. Ex:
  #   Map instance => "maps", GeoData instance => "geo_data"
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

  # Side pane used only with splitted layout
  def side_pane_partial
    @side_pane || "#{controller_ref}/side_pane"
  end

  # Params to be passed locally when rendering partials.Ex:
  #   # object is a Map instance
  #   presenter.object_params
  #   # => { map: map_instance }
  #
  #   # object is a GeoData instance
  #   presenter.object_params(f: form_builder)
  #   # => { geo_data: geo_data_instance, f: form_builder}
  #
  def object_params(hash={})
    {object_ref => object}.merge hash
  end

  # Check if should render the location partial.
  # Only hides if `show_location: false` is given on initialize.
  def hide_location?
    try(:show_location) == false
  end

  # Check if should render the toolbar partial.
  # Only hides if `show_toolbar: false` is given on initialize.
  def hide_toolbar?
    try(:show_toolbar) == false
  end
end
