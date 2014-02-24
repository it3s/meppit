#= require spec_helper
#= require components/flexslider

describe "flexslider", ->
  beforeEach ->
    @container = $ JST['templates/flexslider']()

  it 'initializes component', ->
    sinon.spy(App.components, 'flexslider')
    App.mediator.publish 'components:start', @container

    expect(App.components.flexslider).to.be.called

    App.components.flexslider.restore()

  describe 'component', ->
    beforeEach ->
      @component = App.components.flexslider @container

    it 'calls start', ->
      sinon.spy @component, 'start'

      @component.init()
      expect(@component.start).to.be.called

      @component.start.restore()


    it 'calls jquery-flexslider plugin', ->
      sinon.spy @component.container, 'flexslider'

      @component.init()
      expect(@component.container.flexslider).to.be.calledWith({animation: 'slide'})

      @component.container.flexslider.restore()
