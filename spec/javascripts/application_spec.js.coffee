#= require spec_helper

describe 'Application', ->
  _application = __testing__.application

  describe 'global libs', ->
    it 'defines jQuery', ->
      expect(jQuery).to.not.be.undefined
      expect($).to.be.equal jQuery

    it 'defines underscore', ->
      expect(_).to.not.be.undefined

    it 'defines rails jquery_ujs', ->
      expect($.rails).to.not.be.undefined

  describe 'onRead', ->
    beforeEach -> sinon.spy(App.mediator, 'publish')
    afterEach -> App.mediator.publish.restore()

    it 'trigger components:start', ->
      _application.onReady()
      expect(App.mediator.publish).to.have.been.calledWith('components:start')
