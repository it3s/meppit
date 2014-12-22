#= require spec_helper

describe 'autocomplete', ->
  beforeEach ->
    $('body').html JST['templates/autocomplete']()
    @container = $('.wrapper')

  it 'initializes component', ->
    spy App.components, 'autocomplete', =>
      App.mediator.publish 'components:start', @container
      expect(App.components.autocomplete).to.be.called


  describe 'component', ->
    beforeEach ->
      @component = _base.startComponent 'autocomplete', @container.find('#test')

    describe "initialize", ->
      it "calls autocomplete", ->
        spy @component.container, "autocomplete", =>
          @component.initialize()
          expect(@component.container.autocomplete).to.be.called

    describe "autocompleteTarget", ->
      it "returns the target", ->
        expect(@component.attr.target.length).to.be.equal 1
        expect(@component.attr.target.jquery).to.not.be.undefined

    describe "onSelect", ->
      it "sets val to the target", ->
        expect(@component.attr.target.val()).to.be.equal ""
        @component.onSelect({}, {item: {id: 20}})
        expect(@component.attr.target.val()).to.be.equal "20"
