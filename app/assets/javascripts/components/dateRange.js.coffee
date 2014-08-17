App.components.dateRange = ->
  attributes: ->
    from:   @container.find('[data-date-range=from]')
    to:     @container.find('[data-date-range=to]')
    locale: @getLocale()
    pluginOptions:
      changeMonth: true
      changeYear: true
      dateFormat: 'yy-mm-dd'

  initialize: ->
    @attr.from.datepicker( _.extend {}, @attr.pluginOptions, {
      onClose: (selectedDate) => @attr.to.datepicker('option', 'minDate', selectedDate)
    })

    @attr.to.datepicker( _.extend {}, @attr.pluginOptions, {
      onClose: (selectedDate) => @attr.from.datepicker('option', 'maxDate', selectedDate)
    })

    $.datepicker.setDefaults @attr.locale

  getLocale: ->
    _locale = $('body').data 'locale'
    $.datepicker.regional[_locale] || $.datepicker.regional[""]
