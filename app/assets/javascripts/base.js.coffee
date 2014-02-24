mediator =
  obj: $({})
  publish: (channel, data) -> @obj.trigger(channel, data)
  subscribe: (channel, fn) -> @obj.bind(channel, fn)
  unsubscribe: (channel, fn) -> @obj.unbind(channel, fn)

components = {}

setupContainer = (container) ->
  container = $(container)
  names = container.data('components').split /\s+/
  _.each names, (name) =>
    components[name]?(container).init()
    console.log("component:start => #{name}")

startComponents = (evt, root=document) ->
  $(root).find('[data-components]').each (i, container) =>
    setupContainer(container)

mediator.subscribe 'components:start', startComponents

# App
window.App =
  mediator: mediator
  utils: {}
  components: components

window.__testing__?.base =
  startComponents: startComponents
  setupContainer : setupContainer
