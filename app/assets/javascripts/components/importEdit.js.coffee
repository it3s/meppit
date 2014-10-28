
App.components.importEdit = ->
  errMessage: """
  <div class="err"><i class="fa fa-exclamation-triangle"></i><%= msg %></div>
  """

  attributes: ->
    submitBtn: @container.find('.submit-btn')
    mapInput:  @container.find('#map-autocomplete')
    errsDiv:   @container.find('.validation-errors')

  initialize: ->
    @on @attr.submitBtn, 'click', @onSubmit

  onSubmit: (evt) ->
    @cleanErrors()
    unless @isValid()
      @showErrors()
      evt.preventDefault()

  isValid: ->
    @hasMap() && @allEntriesAreValid()

  hasMap: ->
    _val = @attr.mapInput.val()
    _val && _val.length > 0

  allEntriesAreValid: ->
    @container.find('li.parsed-data.invalid').length is 0

  cleanErrors: ->
    @attr.errsDiv.html ""

  showErrors: ->
    if !@hasMap()
      _tpl = _.template(@errMessage)(msg: I18n.imports.errors.map)
      @attr.errsDiv.append _tpl

    if !@allEntriesAreValid()
      _tpl = _.template(@errMessage)(msg: I18n.imports.errors.invalid)
      @attr.errsDiv.append _tpl
