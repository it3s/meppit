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

##### NEW components ###############

componentBuilder = (name, container) ->
  options: ->
    container.data("#{name.toLowerCase()}-options")

  randomId: ->
    Math.random().toString(36).substring(7)

  getRef: ->
    href = container.attr('href')
    if href?.length > 0 && href isnt "#" then href else undefined

  compId: ->
    _id = container.attr('id') || @getRef() || @randomId()
    "#{name}:#{_id}"

  start: ->
    _comp = components[name]()
    _comp.container = container
    _comp.attr = _.extend(@options(), _comp.attributes?())
    _comp.identifier = @compId()
    _comp.initialize()
    _comp

componentsManager = (container) ->
  container: container

  names: container.data('mpt-components').split /\s+/

  started  : -> @container.data('components-started') || false

  onStarted: -> @container.data('components-started', true)

  buildComponents: ->
    unless @started()
      _.each @names, (name) =>
        componentBuilder(name, @container).start()
        @onStarted()

startMptComponents = (evt, root=document) ->
  $(root).find('[data-mpt-components]').each (i, container) =>
    componentsManager($(container)).buildComponents()

mediator.subscribe 'components:start', startMptComponents

###################################

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

whenComponentStarted = (componentId, fn) ->
  if components._instances[componentId]
    fn()
  else
    mediator.subscribe 'component:started', (evt, _componentId) =>
      fn() if _componentId is componentId

# setup global App namesmpace
window.App =
  mediator  : mediator
  components: components
  utils     :
    flashMessage        : flashMessage
    spinner             : spinner
    whenComponentStarted: whenComponentStarted


# setup testing ns
window.__testing__?.base =
  startComponents: startComponents
  setupContainer : setupContainer
