# Event bus for using pub/sub
mediator =
  obj: $({})
  publish: (channel, data) -> @obj.trigger(channel, data)
  subscribe: (channel, fn) -> @obj.bind(channel, fn)
  unsubscribe: (channel, fn) -> @obj.unbind(channel, fn)

# "async" functions. Returns a deferred object.
asyncFn = (fn) ->
  deferred = $.Deferred()
  setTimeout( ->
    args = fn()
    deferred.resolve(args)
  , 0)
  deferred

# components namespaces
components = { _instances: {} }

# random id generator for components without id
_randomId = ->
  Math.random().toString(36).substring(7)

# component id
_compId = (name, container) ->
  "#{name}:#{container.attr('id') || _randomId()}"

onComponentStarted = (name, container, component) ->
  _id = _compId(name, container)
  components._instances[_id] = component
  container.data('components-started', true)
  mediator.publish 'component:started', _id

# Initialize a component and add the instance to the container data
setupContainer = (container) ->
  container = $(container) unless container.jquery
  names = container.data('components').split /\s+/
  _.each names, (name) =>
    component = components[name]?(container)
    asyncFn ->  component.init()
    .then   ->  onComponentStarted(name, container, component)

# check if the components are already started
containerStarted = (container) ->
  container = $(container) unless container.jquery
  container.data('components-started') || false


# setup all components for a DOM root
startComponents = (evt, root=document) ->
  $(root).find('[data-components]').each (i, container) =>
    setupContainer(container) unless containerStarted(container)


mediator.subscribe 'components:start', startComponents

flashMessage = (msg)->
  flashMsg = $(msg)
  $('body').append(flashMsg)
  mediator.publish 'components:start', flashMsg

spinner = {
  show: ->
    @spinner ||=  $('<div class="modal-spinner"></div>')
    $('body').append(@spinner)
    @spinner.show()

  hide: -> @spinner?.remove()
}

# setup global App namesmpace
window.App =
  mediator    : mediator
  utils       : {}
  components  : components
  flashMessage: flashMessage
  spinner     : spinner


# setup testing ns
window.__testing__?.base =
  startComponents: startComponents
  setupContainer : setupContainer
