window.spy = (obj, property, fn) ->
  sinon.spy(obj, property)
  fn()
  obj[property].restore()
