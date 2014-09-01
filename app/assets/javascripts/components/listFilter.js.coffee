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

  initialize: ->
    @on @attr.toggleBtn, 'click', @toggle
    @on @attr.filterChoice, 'click', @toggleFilter

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
