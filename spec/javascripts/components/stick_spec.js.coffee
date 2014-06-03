#= require spec_helper

describe "stick", ->
  beforeEach ->
    @container = $ JST['templates/stick']()

  it 'initializes component', ->
    spy App.components, 'stick', =>
      App.mediator.publish 'components:start', @container
      expect(App.components.stick).to.be.called


  describe 'component', ->
    beforeEach ->
      @component = App.components.stick @container

    it 'calls jquery-sticky plugin', ->
      spy @component.container, 'sticky', =>
        @component.init()
        expect(@component.container.sticky).to.be.called
