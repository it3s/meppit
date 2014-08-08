App.components.dateRange = (container) ->
  {
    container: container

    init: ->
      @from = @container.find('[data-date-range=from]')
      @to   = @container.find('[data-date-range=to]')

      @startPlugin()

    locale: ->
      _locale = $('body').data 'locale'
      $.datepicker.regional[_locale] || $.datepicker.regional[""]

    startPlugin: ->
      @from.datepicker
        changeMonth: true
        changeYear: true
        dateFormat: 'yy-mm-dd'
        onClose: (selectedDate) => @to.datepicker('option', 'minDate', selectedDate)

      @to.datepicker
        changeMonth: true
        changeYear: true
        dateFormat: 'yy-mm-dd'
        onClose: (selectedDate) => @from.datepicker('option', 'maxDate', selectedDate)

      $.datepicker.setDefaults @locale()
  }

