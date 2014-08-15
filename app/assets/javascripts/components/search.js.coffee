App.components.search = ->
  attributes: ->
    _form = @container.find('form')
    {
      form: _form
      input: @container.find('input#search')
      url: _form.attr('action')
    }

  initialize: ->
    @on @attr.form, 'submit', @onSubmit

  onSubmit: (evt) ->
    evt.preventDefault()
    @doSearch()
    false

  doSearch: ->
    search_term = @attr.input.val()
    return if search_term?.length is 0

    App.utils.spinner.show()
    $.ajax
      type:    'POST'
      url:     @attr.url
      data:    {term: search_term}
      success: @onSuccess.bind(this)

  onSuccess: (data) ->
    App.utils.spinner.hide()
    @showResults data

  showResults: (content) ->
    $('#search-results-wrapper').remove()
    results_content = $(content)
    $('body').append(results_content)
    App.mediator.publish "components:start", results_content
