App.components.search = (container) ->
  {
    container: container

    init: ->
      console.log 'initializing search'
      @form = @container.find('form')
      @input = @container.find('input#search')
      @bindEvents()

    doSearch: ->
      @timeout_fn = null
      search_term = @input.val()

      return if search_term?.length is 0

      console.log 'performing search for ', @input.val()
      # # Komoo Search
      # $.ajax
      #     type: 'POST'
      #     url: dutils.urls.resolve('komoo_search')
      #     data: {term: search_term, 'csrfmiddlewaretoken': csrftoken}
      #     dataType: 'json'
      #     success: (data) ->
      #         showResults data.result, search_term

    onSubmit: (evt) ->
      evt.preventDefault()
      clearTimeout @timeout_fn if @timeout_fn
      @doSearch()
      false

    onEntry: (evt) ->
      if @input.val().length > 2
        clearTimeout @timeout_fn if @timeout_fn
        @timeout_fn = setTimeout @doSearch.bind(this), 500

    bindEvents: ->
      @timeout_fn = null
      @form.submit @onSubmit.bind(this)
      @form.bind 'keyup', @onEntry.bind(this)


  }
