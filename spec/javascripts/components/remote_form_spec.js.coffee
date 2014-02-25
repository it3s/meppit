#= require spec_helper

describe 'remoteForm', ->
  beforeEach ->
    @container = $ JST['templates/remote_form']()

  it 'defines remoteForm component', ->
    expect(App.components.remoteForm).to.not.be.undefined


  it 'initializes component', ->
    spy App.components, 'remoteForm', =>
      App.mediator.publish 'components:start', @container
      expect(App.components.remoteForm).to.be.called



  # describe 'component', ->
  #   beforeEach ->
  #     container = @container.find('#modal-link')
  #     @component = App.components.modal container
