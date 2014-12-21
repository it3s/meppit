#= require spec_helper

describe 'alert', ->
  beforeEach ->
    @clock = sinon.useFakeTimers()
    $('body').html JST['templates/alert']()
    @container = $('.alerts')

  afterEach ->
    @clock.restore()

  it 'initializes component', ->
    spy App.components, 'alert', =>
      App.mediator.publish 'components:start', @container
      expect(App.components.alert).to.be.called

  describe 'component', ->
    beforeEach ->
      @component = _base.startComponent 'alert', @container.find('.alert')
      @attributes = @component.attributes()

    it 'defines a fadeTime', ->
      expect(@component.attr.fadeTime).to.not.be.undefined

    it 'set closeButton', ->
      @component.initialize()
      expect(@component.attr.closeButton.length).to.be.equal 1
      expect(@component.attr.closeButton.is 'a.close').to.be.true

    it 'calls bindEvents', ->
      spy @component, 'bindEvents', =>
        @component.initialize()
        expect(@component.bindEvents).to.be.called

    it 'bind click on closeButton to close', ->
      @component.initialize()
      spy @component.attr.closeButton, 'on', =>
        @component.bindEvents()
        expect(@component.attr.closeButton.on).to.be.calledWith 'click'

    it 'on close fade out and removes the alert', ->
      sinon.spy @component.container, 'fadeOut'

      @component.attr.fadeTime = 0
      @component.initialize()
      @component.close()
      expect(@component.container.fadeOut).to.be.called

      @component.container.fadeOut.restore()
      @clock.tick(@component.attr.fadeTime)
      expect( $('.alert').length ).to.be.equal 0
      expect( $('.alerts').length ).to.be.equal 0
