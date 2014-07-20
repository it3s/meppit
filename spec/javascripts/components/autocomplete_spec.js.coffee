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
      @component = App.components.autocomplete @container.find('#test')

    describe "init", ->
      it "sets data", ->
        @component.init()
        expect(@component.data).to.be.deep.equal {"name":"test","url":"/"}

      it "start plugin", ->
        spy @component, 'startPlugin', =>
          @component.init()
          expect(@component.startPlugin).to.be.called

    describe "autocompleteTarget", ->
      it "returns the target", ->
        @component.init()
        expect(@component.autocompleteTarget().length).to.be.equal 1
        expect(@component.autocompleteTarget().jquery).to.not.be.undefined

    describe "onSelect", ->
      it "sets val to the target", ->
        @component.init()
        expect(@component.autocompleteTarget().val()).to.be.equal ""
        @component.onSelect({}, {item: {id: 20}})
        expect(@component.autocompleteTarget().val()).to.be.equal "20"

    describe "startPlugin", ->
      it "calls autocomplete", ->
        spy @component.container, "autocomplete", =>
          @component.init()
          expect(@component.container.autocomplete).to.be.called






