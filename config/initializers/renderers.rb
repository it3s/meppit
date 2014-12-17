require 'action_controller/metal/renderers'

ActionController.add_renderer :geojson do |resource, options|
  self.response_body = resource.respond_to?(:to_geojson) ? resource.to_geojson : resource
end

ActionController.add_renderer :csv do |resource, options|
  self.response_body = resource.respond_to?(:to_csv) ? resource.to_csv : resource
end
