#= require spec_helper

describe 'uploader', ->
  beforeEach ->
    $('body').html JST['templates/uploader']()
    @container = $('.uploader-input')
    window.I18n = uploader: {uploaded: '', select_image: '', uploading: ''}

  it 'initializes component', ->
    spy App.components, 'uploader', =>
      App.mediator.publish 'components:start'
      expect(App.components.uploader).to.be.called


  describe 'component', ->
    beforeEach ->
      @component = _base.startComponent 'uploader', @container

    it 'hides input', ->
      @component.render()
      expect($('.field').css 'display').to.be.eq 'none'

    it 'gets the field name', ->
      expect(@component.fieldName()).to.be.eq 'avatar'

    it 'adds the necessary markup', ->
      expect($('.uploader').length).to.be.eq 1
      expect(@component.attr.button).to.not.be.undefined
      expect(@component.container.closest('.field').next().is('.uploader')).to.be.true

    it 'binds events', ->
      spy @component.attr.button, 'on', =>
        @component.bindEvents()
        expect(@component.attr.button.on).to.be.calledWith 'click'

        sinon.stub @component.container, 'trigger', -> ''
        @component.attr.button.trigger 'click'
        expect(@component.container.trigger).to.be.calledWith 'click'
        @component.container.trigger.restore()

    it 'calls jquery-fileupload on startPlugin', ->
      spy @component.container, 'fileupload', =>
        @component.startPlugin()
        expect(@component.container.fileupload).to.be.called

    it 'starts plugin on initialize', ->
      spy @component, 'startPlugin', =>
        @component.initialize()
        expect(@component.startPlugin).to.be.called

    it 'adds error message when fail', ->
      @component.initialize()
      _data = {jqXHR: {responseJSON:{ errors: {avatar: ['Upload error']}}}}

      spy @component, 'startPlugin', =>
        @component.onFail({}, _data)
        errEl = @component.attr.uploader.find('.error')

        expect(errEl.length).to.be.eq 1
        expect(errEl.text()).to.be.eq 'Upload error'
        expect(@component.startPlugin).to.be.called
