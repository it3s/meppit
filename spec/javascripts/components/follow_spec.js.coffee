#= require spec_helper

describe 'follow', ->
  beforeEach ->
    $('body').html JST['templates/follow']()
    @container = $('#follow-btn')
    window.I18n = followings: { follow: '', unfollow: '', following: '' }

  it 'initializes component', ->
    spy App.components, 'follow', =>
      App.mediator.publish 'components:start', @container
      expect(App.components.follow).to.be.called

  describe 'component', ->
    beforeEach ->
      @component = _base.startComponent 'follow', @container

    context 'active', ->
      beforeEach ->
        @component.toggleActive(true)

      it '#isActive returns true', ->
        expect(@component.isActive()).to.be.true

      it '#requestData returns delete', ->
        expect(@component.requestData()._method).to.be.equal 'delete'

      it '#toggleActive remove class', ->
        expect(@container.is('.active')).to.be.true
        @component.toggleActive()
        expect(@container.is('.active')).to.be.false

    context 'inactive', ->
      beforeEach ->
        @component.toggleActive(false)

      it '#isActive returns false', ->
        expect(@component.isActive()).to.be.false

      it '#requestData returns post', ->
        expect(@component.requestData()._method).to.be.equal 'post'

      it '#toggleActive add class', ->
        expect(@container.is('.active')).to.be.false
        @component.toggleActive()
        expect(@container.is('.active')).to.be.true
