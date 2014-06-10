#= require spec_helper

describe "list", ->
  beforeEach ->
    @container = $ JST['templates/list']()

  it 'initializes component', ->
    spy App.components, 'list', =>
      App.mediator.publish 'components:start', @container
      expect(App.components.list).to.be.called


  describe 'component', ->
    beforeEach ->
      @container = $ JST['templates/list']()
      @component = App.components.list @container

    it 'calls infinite-scroll plugin', ->
      spy @component.list, 'infinitescroll', =>
        @component.init()
        expect(@component.list.infinitescroll).to.be.calledWith @component.infiniteScrollDefaults
