App.components.search = (container) ->
  {
    container: container

    init: ->
      @form = @container.find('form')
      @input = @container.find('input#search')
      @bindEvents()

    showResults: (content) ->
      @input.qtip
        content: content
        style:
          classes: 'search-tooltip tooltip qtip-light qtip-shadow qtip-rounded'
        hide:
          event: 'unfocus'
        position:
          my: 'top center'
          adjust:
            x: -235, y: 5
      @input.qtip("show")
      App.mediator.publish "components:start", $("#search-results")

    onSuccess: (data) ->
      @showResults data

    doSearch: ->
      _this = this
      @timeout_fn = null
      search_term = @input.val()
      url = @form.attr('action')

      return if search_term?.length is 0

      # hide and destroy tooltip with older results
      @input.qtip("hide").qtip("destroy")

      $.ajax
        type: 'POST'
        url: url
        data: {term: search_term}
        success: _this.onSuccess.bind(_this)


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
      @input.bind 'mouseover', (evt) -> evt.preventDefault()

  }
