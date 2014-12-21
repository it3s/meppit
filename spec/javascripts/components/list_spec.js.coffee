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
      @component = _base.startComponent 'list', @container

    it 'calls infinite-scroll plugin', ->
      spy @component.attr.list, 'infinitescroll', =>
        @component.initialize()
        expect(@component.attr.list.infinitescroll).to.be.calledWith @component.attr.infiniteScrollDefaults
