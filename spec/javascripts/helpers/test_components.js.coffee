App.components.testComponent = (container) ->
  {
    container: container
    initialize: sinon.spy( ->
      @container.find('h1').html('Hello')
    )
  }

App.components.otherComponent = (container) ->
  {
    container: container
    initialize: sinon.spy( -> 'other')
  }
