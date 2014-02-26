#= require spec_helper

describe 'alert', ->
  beforeEach ->
    $('body').html JST['templates/alert']()
    @container = $('.alerts')

  it 'initializes component', ->
    spy App.components, 'alert', =>
      App.mediator.publish 'components:start', @container
      expect(App.components.alert).to.be.called


  describe 'component', ->
    beforeEach ->
      @component = App.components.alert @container.find('.alert')

    it 'defines a fadeTime', ->
      expect(@component.fadeTime).to.not.be.undefined

    it 'set closeButton', ->
      @component.init()
      expect(@component.closeButton.length).to.be.equal 1
      expect(@component.closeButton.is 'a.close').to.be.true

    it 'calls bindEvents', ->
      spy @component, 'bindEvents', =>
        @component.init()
        expect(@component.bindEvents).to.be.called

    it 'bind click on closeButton to close', ->
      @component.init()
      spy @component.closeButton, 'on', =>
        @component.bindEvents()
        expect(@component.closeButton.on).to.be.calledWith 'click'

    it 'on close fade out and removes the alert', (done)->
      sinon.spy @component.container, 'fadeOut'

      @component.init()
      @component.close(@component)
      expect(@component.container.fadeOut).to.be.called

      @component.container.fadeOut.restore()
      setTimeout( =>
        expect( $('.alert').length ).to.be.equal 0
        expect( $('.alerts').length ).to.be.equal 0
        done()

      , @component.fadeTime)

