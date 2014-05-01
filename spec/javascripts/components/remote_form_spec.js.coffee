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

    describe 'onError', ->
      it 'adds a general .error.all message when passes string', ->
        @component.onError(null, {errors: "__err__"})
        errorDiv = @component.container.find('.error.all')
        expect(errorDiv.length).to.be.equal 1
        expect(errorDiv.text()).to.be.equal '__err__'
        expect(errorDiv.next().find('input').is('[type=submit]')).to.be.true

      it 'adds each error to the corresponding field', ->
        @component.onError(null, errors: {"name": ["__err__"]})
        errorDiv = @component.container.find('.error')
        expect(errorDiv.length).to.be.equal 1

        nameField = @component.container.find('.field.test_name')
        expect(nameField.is('.field_with_errors')).to.be.true
        expect(nameField.find('.error').text()).to.be.equal '__err__'

        otherField = @component.container.find('.field.test_other')
        expect(otherField.is('.field_with_errors')).to.be.false
        expect(otherField.find('.error').length).to.be.equal 0

    describe 'bindEvents', ->
      it 'bind onError to ajax:error event', ->
        spy @component.container, 'on', =>
          @component.bindEvents()
          expect(@component.container.on).to.be.calledWith 'ajax:complete'

          spy @component, 'onError', =>
            @component.container.trigger 'ajax:complete', {status: 422, responseText: '{"errors": {"name": "__err__"}}'}
            expect(@component.onError).to.be.called

      it 'bind onSuccess to ajax:success event', ->
        spy @component.container, 'on', =>
          @component.bindEvents()
          expect(@component.container.on).to.be.calledWith 'ajax:complete'

          spy @component, 'onSuccess', =>
            @component.container.trigger 'ajax:complete', {status: '200', responseText: '{}'}
            expect(@component.onSuccess).to.be.called


