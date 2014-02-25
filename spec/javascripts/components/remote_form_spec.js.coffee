#= require spec_helper

describe 'remoteForm', ->
  beforeEach ->
    @container = $ JST['templates/remote_form']()

  it 'defines remoteForm component', ->
    expect(App.components.remoteForm).to.not.be.undefined


  it 'initializes component', ->
    spy App.components, 'remoteForm', =>
      App.mediator.publish 'components:start', @container
      expect(App.components.remoteForm).to.be.called


  describe 'component', ->
    beforeEach ->
      container = @container.find('form')
      @component = App.components.remoteForm container

    it 'on init call bindEvents', ->
      spy @component, 'bindEvents', =>
        @component.init()
        expect(@component.bindEvents).to.be.called

    describe 'cleanErrors', ->
      beforeEach ->
        @component.container.find('.field').addClass 'field_with_errors'
        @component.container.find('.field').append '<div class="error">error message</div>'

      it 'removes previous errors', ->
        @component.cleanErrors()
        expect(@component.container.find('.error').length).to.be.equal 0

      it 'removes field_with_errors class from fields', ->
        @component.cleanErrors()
        expect(@component.container.find('.field_with_errors').length).to.be.equal 0
