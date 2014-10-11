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
    if not components[name]?
      console?.error "Component not found: #{name}"
      return
    console?.log "Starting Component: #{name}"
    _comp = components[name]()
    _comp.container = container
    _comp.identifier = @compId()
    _comp.attr = _.extend {}, @options()
    _comp.attr = _.extend _comp.attr, _comp.attributes?()

    _comp.on = (target_or_evt, evt_or_cb, cb) ->
      [target, evt, fn] = if _.isString(target_or_evt) && _.isFunction(evt_or_cb)
                            [_comp.container, target_or_evt, evt_or_cb]
                          else
                            [target_or_evt, evt_or_cb, cb]

      target.on evt, fn.bind(_comp)

    _comp.initialize()
    _comp

componentsManager = (container) ->
  container: container

  names: container.data('components').split /\s+/

  started  : -> @container.data('components-started') || false

  onStarted: -> @container.data('components-started', true)

  buildComponents: ->
    unless @started()
      _.each @names, (name) =>
        componentBuilder(name, @container).start()
        @onStarted()

startComponents = (evt, root=document) ->
  attr = 'data-components'
  $root = $ root
  componentsManager($root).buildComponents() if $root.attr(attr)
  $root.find("[#{attr}]").each (i, container) =>
    componentsManager($(container)).buildComponents()

mediator.subscribe 'components:start', startComponents

stickyRecalc = () ->
  setTimeout () -> $(document.body).trigger 'sticky_kit:recalc', 100

componentInitialized = (evt, component) ->
  console.log "Component Initialized: #{component}"
  stickyRecalc()

mediator.subscribe 'component:initialized', componentInitialized

componentChanged = (evt, component) ->
  console.log "Component Changed: #{component}"
  stickyRecalc()

mediator.subscribe 'component:changed', componentChanged


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
  mediator  : mediator
  components: components
  utils     :
    flashMessage: flashMessage
    spinner     : spinner


# setup testing ns
window.__testing__?.base =
  startComponents: startComponents
