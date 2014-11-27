App.components.embedder = ->
  attributes: ->
    optionsEl: @container.find('.options')
    codeInput: @container.find('#embed-code')

  initialize: ->
    @options =
      width:  800
      height: 450
      style:  "border:none;"

    @populateCodeArea()
    @bindEvents()
    @attr.codeInput.select()

  url: ->
    "#{@attr.baseUrl}"

  code: ->
    "<iframe src=\"#{@url()}\" width=\"#{@options.width}\" height=\"#{@options.height}\" style=\"#{@options.style}\"></iframe>"

  populateCodeArea : ->
    @attr.codeInput.val @code()

  bindEvents: ->
    @attr.codeInput.focus =>
      @attr.codeInput.select()

      # Work around Chrome's little problem
      @attr.codeInput.mouseup =>
        # Prevent further mouseup intervention
        @attr.codeInput.unbind "mouseup"
        return false
