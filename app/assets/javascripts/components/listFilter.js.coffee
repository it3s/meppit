expanded = """
<i class="fa fa-chevron-up"></i> #{I18n.lists.collapse}
"""
collapsed = """
<i class="fa fa-chevron-down"></i> #{I18n.lists.expand}
"""

App.components.listFilter = ->
  attributes: ->
    toggleBtn:    @container.find('.toggle-panel')
    filtersForm:  @container.find('.filters')
    filterChoice: @container.find('input[data-filter]')
    sortChoice:   @container.find('.choice input[type=radio]')
    tags:         @container.find('input#filter_tags')
    tagsId:       'tags:filter_tags'
    applyBtn:     @container.find('.apply-btn')
    params:       {filters: {}, sort_by: 'name', visualization: 'list'}

  initialize: ->
    @on @attr.toggleBtn,    'click', @toggle
    @on @attr.filterChoice, 'click', @toggleFilter

    @on @attr.sortChoice,  'click',        @choiceChanged
    App.mediator.subscribe 'tags:changed', @tagsChanged.bind(this)

  toggle: ->
    if @isExpanded() then @collapse() else @expand()

  isExpanded: ->
    @attr.toggleBtn.data('toggle') is 'expanded'

  collapse: ->
    @attr.filtersForm.slideUp('fast')
    @attr.toggleBtn.data('toggle', 'collapsed')
    @attr.toggleBtn.html collapsed

  expand: ->
    @attr.filtersForm.slideDown('fast')
    @attr.toggleBtn.data('toggle', 'expanded')
    @attr.toggleBtn.html expanded

  toggleFilter: (evt)->
    el = $ evt.target
    panel = @container.find el.data('filter')
    panel.slideToggle 'fast'
    @updateLink()

  choiceChanged: (evt) ->
    el = $ evt.target
    @attr.params[el.attr('name')] = el.val()
    @updateLink()

  tagsChanged: (evt, data) ->
    if data.identifier is @attr.tagsId
      @attr.params.filters = if data.tags.length > 0 then {tags: data.tags} else {}
      @updateLink()

  updateLink: ->
    p = @attr.params
    query = []

    if (!_.isEmpty(p.filters)) && @attr.filterChoice.prop('checked')
      query.push "filters=#{ _.keys(p.filters).join(',') }"
      _.each p.filters, (val, key) -> query.push "#{key}=#{val}"

    query.push "sort_by=#{p.sort_by}" if p.sort_by isnt 'name'
    query.push "visualization=#{p.visualization}" if p.visualization isnt 'list'

    href = if query.length > 0 then '?' + query.join('&') else '#'
    @attr.applyBtn.attr 'href', href





