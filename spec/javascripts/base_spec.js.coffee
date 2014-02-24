#= require spec_helper

describe 'Base', ->
  _base = __testing__.base

  describe 'mediator', ->
    it 'defines obj mediator', ->
      expect(App.mediator.obj).to.be.a 'object'

  describe 'subscribe', ->
    beforeEach -> sinon.spy(App.mediator.obj, 'bind')
    afterEach -> App.mediator.obj.bind.restore()

    it 'subscribes to event', ->
      cb = -> 'ok'
      App.mediator.subscribe 'test-event', cb
      expect(App.mediator.obj.bind).to.be.calledWith('test-event', cb)

  describe 'publish', ->
    beforeEach -> sinon.spy(App.mediator.obj, 'trigger')
    afterEach -> App.mediator.obj.trigger.restore()

    it 'publishes event', ->
      App.mediator.publish 'test-event', 'ok'
      expect(App.mediator.obj.trigger).to.be.calledWith('test-event', 'ok')

  describe 'unsubscribe', ->
    beforeEach -> sinon.spy(App.mediator.obj, 'unbind')
    afterEach -> App.mediator.obj.unbind.restore()

    it 'unsubscribes to event', ->
      cb = -> 'ok'
      App.mediator.unsubscribe 'test-event', cb
      expect(App.mediator.obj.unbind).to.be.calledWith('test-event', cb)

  describe 'pub/sub', ->

    it 'listen properly to events', ->
      cb = sinon.spy (evt, data) -> "received #{data}"

      App.mediator.subscribe 'test-event', cb
      App.mediator.publish 'test-event', 'ok'

      expect(cb).to.be.called
      expect(cb).to.have.returned 'received ok'

