# Mediator
mediator =
  obj: $({})
  publish: (channel, data) ->
    @obj.trigger(channel, data)
  subscribe: (channel, fn) ->
    @obj.bind(channel, fn)
  unsubscribe: (channel, fn) ->
    @obj.unbind(channel, fn)

# Utils
utils = {}

# App
window.App =
  mediator: mediator
  utils: utils
