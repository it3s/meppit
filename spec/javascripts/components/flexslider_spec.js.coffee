#= require spec_helper
#= require components/flexslider

describe "flexslider", ->
  beforeEach ->
    @container = $ JST['templates/flexslider']()

  it 'initializes component', ->
    spy App.components, 'flexslider', =>
      App.mediator.publish 'components:start', @container
      expect(App.components.flexslider).to.be.called


  describe 'component', ->
    beforeEach ->
      @component = App.components.flexslider @container

    it 'calls start', ->
      spy @component, 'start', =>
        @component.init()
        expect(@component.start).to.be.called

    it 'calls jquery-flexslider plugin', ->
      spy @component.container, 'flexslider', =>
        @component.init()
        expect(@component.container.flexslider).to.be.calledWith({animation: 'slide'})
