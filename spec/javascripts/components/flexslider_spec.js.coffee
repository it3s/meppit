#= require spec_helper

describe "flexslider", ->
  beforeEach ->
    @container = $ JST['templates/flexslider']()

  it 'initializes component', ->
    spy App.components, 'flexslider', =>
      App.mediator.publish 'components:start', @container
      expect(App.components.flexslider).to.be.called


  describe 'component', ->
    beforeEach ->
      @component = _base.startComponent 'flexslider', @container

    it 'calls jquery-flexslider plugin', ->
      spy @component.container, 'flexslider', =>
        @component.initialize()
        expect(@component.container.flexslider).to.be.calledWith({animation: 'slide'})
