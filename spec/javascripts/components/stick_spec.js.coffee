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
      @component = _base.startComponent 'stick', @container

    it 'calls jquery-sticky plugin', ->
      spy @component.container, 'sticky', =>
        @component.initialize()
        expect(@component.container.sticky).to.be.called
