#= require spec_helper
#= require components/uploader

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
      @component = App.components.uploader @container

    it 'hides input', ->
      @component.hideInput()
      expect($('.field').css 'display').to.be.eq 'none'

    it 'adds the necessary markup', ->
      expect(@component.message).to.be.undefined
      expect(@component.button).to.be.undefined

      @component.addUploaderHtml()

      expect($('.uploader').length).to.be.eq 1
      expect(@component.message).to.not.be.undefined
      expect(@component.button).to.not.be.undefined
      expect(@component.container.closest('.field').next().is('.uploader')).to.be.true

    it 'binds events', ->
      @component.addUploaderHtml()
      spy @component.button, 'on', =>
        @component.bindEvents()
        expect(@component.button.on).to.be.calledWith 'click'

        sinon.stub @component.container, 'trigger', -> ''
        @component.button.trigger 'click'
        expect(@component.container.trigger).to.be.calledWith 'click'
        @component.container.trigger.restore()

    it 'calls jquery-fileupload on startPlugin', ->
      spy @component.container, 'fileupload', =>
        @component.startPlugin()
        expect(@component.container.fileupload).to.be.called

    it 'starts plugin on init', ->
      spy @component, 'startPlugin', =>
        @component.init()
        expect(@component.startPlugin).to.be.called
