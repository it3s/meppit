#= require spec_helper

describe 'editor', ->
  beforeEach ->
    $('body').html JST['templates/editor']()
    $('body').data('locale', 'en')
    @container = $('#test-editor')

  it 'initializes component', ->
    spy App.components, 'editor', =>
      App.mediator.publish 'components:start'
      expect(App.components.editor).to.be.called


  describe 'component', ->
    beforeEach ->
      @component = App.components.editor @container

    it 'defines defaults', ->
      expect(@component.defaults).to.be.an 'object'

    it 'get locale from body', ->
      expect(@component.getLocale()).to.be.equal 'en'
      $('body').data 'locale', 'pt-BR'
      expect(@component.getLocale()).to.be.equal 'pt_BR'

    it 'build options hash',->
      expect(@component.options()).to.be.deep.equal _.extend({}, @component.defaults, {
        selector: "textarea#test-editor"
        language: "en"
      })

    it 'starts tinymce', ->
      spy tinyMCE, 'init', =>
        @component.init()
        expect(tinyMCE.init).to.be.calledWith @component.options()

