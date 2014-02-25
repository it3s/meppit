#= require spec_helper
#= require helpers/test_components

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

  describe 'setupContainer', ->
    it 'initializes component', ->
      container = $(JST['templates/test_component']())
      _base.setupContainer(container)

      component = App.components._instances['testComponent:test']
      expect(component.init).to.be.called
      expect(container.find('h1').html()).to.be.equal 'Hello'

    it 'instantiates multi components', ->
      container = $(JST['templates/multi_component']())

      _base.setupContainer(container)

      component1 = App.components._instances['testComponent:multi']
      component2 = App.components._instances['otherComponent:multi']
      expect(component1.init).to.be.called
      expect(component2.init).to.be.called

  describe 'startComponents', ->
      beforeEach ->
        $('body').html(JST['templates/start_components']())

      it 'start all components on the body', ->
        _base.startComponents()

        component1 = App.components._instances['testComponent:test']
        component2 = App.components._instances['otherComponent:other']
        expect(component1.init).to.be.called
        expect(component2.init).to.be.called


      it 'listens to components:start event and receive a different root', ->
        spy App.components, 'testComponent', =>
          spy App.components, 'otherComponent', =>
            App.mediator.publish 'components:start', $('#root')

            expect(App.components.testComponent).to.not.be.called
            expect(App.components.otherComponent).to.be.called
