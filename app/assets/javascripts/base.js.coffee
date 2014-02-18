mediator =
  obj: $({})
  publish: (channel, data) -> @obj.trigger(channel, data)
  subscribe: (channel, fn) -> @obj.bind(channel, fn)
  unsubscribe: (channel, fn) -> @obj.unbind(channel, fn)

components = {}

setup_container = (container) ->
  container = $(container)
  names = container.data('components').split /\s+/
  _.each names, (name) =>
    components[name]?(container).init()

start_components = ->
  $(document).find('[data-components]').each (i, container) =>
    setup_container(container)

mediator.subscribe 'components:start', start_components

# App
window.App =
  mediator: mediator
  utils: {}
  components: components
