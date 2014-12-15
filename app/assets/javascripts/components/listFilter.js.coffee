expanded = """
<i class="fa fa-chevron-up"></i> #{I18n.lists.collapse}
"""
collapsed = """
<i class="fa fa-chevron-down"></i> #{I18n.lists.expand}
"""

App.components.listFilter = ->
  attributes: ->
    toggleBtn:      @container.find('.toggle-panel')
    sortByRadio:    @container.find('input[name="list_filter[sort_by]"]')
    longitudeField: @container.find('#list_filter_longitude')
    latitudeField:  @container.find('#list_filter_latitude')
    orderSection:   @container.find('.filter-order')
    filterForm:     @container.find('.filter-form')

  initialize: ->
    @bindEvents()
    @toggleSortSection()

  bindEvents: ->
    @on @attr.toggleBtn,   'click',  @toggle
    @on @attr.sortByRadio, 'change', @sortByChanged

  toggle: ->
    if @isExpanded() then @collapse() else @expand()

  isExpanded: ->
    @attr.toggleBtn.data('toggle') is 'expanded'

  collapse: ->
    @attr.filterForm.slideUp('fast')
    @attr.toggleBtn.data('toggle', 'collapsed')
    @attr.toggleBtn.html collapsed

  expand: ->
    @attr.filterForm.slideDown('fast')
    @attr.toggleBtn.data('toggle', 'expanded')
    @attr.toggleBtn.html expanded

  wait: ->
    App.utils.spinner.show()

  done: ->
    App.utils.spinner.hide()

  sortByChanged: ->
    selected = @attr.sortByRadio.filter(':checked')
    @locate() if selected.val() is 'location'
    @toggleSortSection()

  toggleSortSection: ->
    selected = @attr.sortByRadio.filter(':checked')
    if selected.val() is 'location'
      @attr.orderSection.fadeOut()
    else
      @attr.orderSection.show()

  locate: ->
    @wait()
    navigator.geolocation?.getCurrentPosition (pos) =>
      @attr.longitudeField.val(pos.coords.longitude)
      @attr.latitudeField.val(pos.coords.latitude)
      @done()
    , =>
      # TODO: treat the geolocation error
      @done()
