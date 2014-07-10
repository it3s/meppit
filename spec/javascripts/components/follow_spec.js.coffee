#= require spec_helper

describe 'follow', ->
  beforeEach ->
    $('body').html JST['templates/follow']()
    @container = $('#follow-btn')

  it 'initializes component', ->
    spy App.components, 'follow', =>
      App.mediator.publish 'components:start'
      expect(App.components.follow).to.be.called

  describe 'component', ->
    beforeEach ->
      @component = App.components.follow @container
      @component.init()

    context 'active', ->
      beforeEach ->
        @component.toggleActive(true)

      it '#isActive returns true', ->
        expect(@component.isActive()).to.be.true

      it '#method returns delete', ->
        expect(@component.method()).to.be.equal 'delete'

      it '#toggleActive remove class', ->
        expect(@container.is('.active')).to.be.true
        @component.toggleActive()
        expect(@container.is('.active')).to.be.false

    context 'inactive', ->
      beforeEach ->
        @component.toggleActive(false)

      it '#isActive returns false', ->
        expect(@component.isActive()).to.be.false

      it '#method returns post', ->
        expect(@component.method()).to.be.equal 'post'

      it '#toggleActive add class', ->
        expect(@container.is('.active')).to.be.false
        @component.toggleActive()
        expect(@container.is('.active')).to.be.true

