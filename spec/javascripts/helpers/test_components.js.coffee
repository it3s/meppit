App.components.testComponent = (container) ->
  {
    container: container
    init: sinon.spy( ->
      @container.find('h1').html('Hello')
    )
  }

App.components.otherComponent = (container) ->
  {
    container: container
    init: sinon.spy( -> 'other')
  }
