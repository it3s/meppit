#= require spec_helper

describe 'editor', ->
  beforeEach ->
    $('body').html JST['templates/editor']()
    $('body').data('locale', 'en')
    @container = $('#test-editor')

  it 'initializes component', (done) ->
    spy App.components, 'editor', =>
      spy tinyMCE, 'init', =>
        App.mediator.subscribe 'component:initialized', -> done()
        App.mediator.publish 'components:start', @container
        expect(App.components.editor).to.be.called
        expect(tinyMCE.init).to.be.called

  describe 'component', ->
    beforeEach ->
      @component = _base.startComponent 'editor', @container

    it 'defines options', ->
      expect(@component.attr.pluginOptions).to.be.an 'object'

    it 'gets locale from body', ->
      expect(@component.attributes().pluginOptions.language).to.be.equal 'en'
      $('body').data 'locale', 'pt-BR'
      expect(@component.attributes().pluginOptions.language).to.be.equal 'pt_BR'

    it 'sets selector',->
      expect(@component.attributes().pluginOptions.selector).to.be.equal "textarea#test-editor"
