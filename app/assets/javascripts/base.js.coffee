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

randomId = ->
  Math.random().toString(36).substring(7)

getRef = (container) ->
  href = container.attr('href')
  if href?.length > 0 && href isnt "#" then href else undefined

compId = (name, container) ->
  _id = container.attr('id') || getRef(container) || randomId(container)
  "#{name}:#{_id}"

# components namespaces
components =
  _instances: {}

  _getInstanceFor: (name, container) ->
    components._instances[compId(name, container)]

  _getInstancesFor: (container) ->
    comps = container.data('components')?.split ' '
    _.map comps, (name) ->
      components._getInstanceFor name, container

componentBuilder = (name, container) ->
  options: ->
    container.data("#{name.toLowerCase()}-options")

  compId: ->
    compId name, container

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
    components._instances[_comp.identifier] = _comp
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

# declare jQuery functions
(($) ->
  $.fn.setComponentValue = (name, value) ->
    if value is undefined
      value = name
      _.each components._getInstancesFor(this), (instance) ->
        instance.setValue? value
    else
      components._getInstanceFor(name, this)?.setValue? value
    this
)(jQuery)

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
