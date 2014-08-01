App.components.search = (container) ->
  {
    container: container

    init: ->
      @form = @container.find('form')
      @input = @container.find('input#search')
      @bindEvents()

    showResults: (content) ->
      $('#search-results-wrapper').remove()
      results_content = $(content)
      $('body').append(results_content)
      App.mediator.publish "components:start", results_content

    onSuccess: (data) ->
      App.utils.spinner.hide()
      @showResults data

    doSearch: ->
      _this = this
      search_term = @input.val()
      url = @form.attr('action')

      return if search_term?.length is 0

      App.utils.spinner.show()
      $.ajax
        type: 'POST'
        url: url
        data: {term: search_term}
        success: _this.onSuccess.bind(_this)


    onSubmit: (evt) ->
      evt.preventDefault()
      @doSearch()
      false

    bindEvents: ->
      @timeout_fn = null
      @form.submit @onSubmit.bind(this)

  }
