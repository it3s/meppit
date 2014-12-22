#= require spec_helper

describe 'modal', ->
  beforeEach ->
    @container = $ JST['templates/modal']()
    @clock = sinon.useFakeTimers()

  afterEach ->
    @clock.restore()

  it 'defines modal component', ->
    expect(App.components.modal).to.not.be.undefined

  it 'initializes component', ->
    spy App.components, 'modal', =>
      App.mediator.publish 'components:start', @container
      expect(App.components.modal).to.be.called

  describe 'component', ->
    beforeEach ->
      container = @container.find('#modal-link')
      @component = _base.startComponent 'modal', container

    it 'has defaults', ->
      expect(@component.attr.defaults.fadeDuration).to.be.equal 150
      expect(@component.attr.defaults.zIndex).to.be.equal 200

    it 'sets preventClose options', ->
      expect(@component.attr.preventCloseOpts).to.be.deep.equal {
        escapeClose: false
        clickClose: false
        closeText: ''
        showClose: false
      }

    it 'gets the referedElement', ->
      expect(@component.referedElement().selector).to.be.equal '#test'

    describe 'regular modal', ->
      it 'set target to referedElement', ->
        expect(@component.attr.target.selector).to.be.equal '#test'

      it 'opens the target as a modal with defaults', ->
        spy @component.attr.target, 'modal', =>
          @component.open()
          expect(@component.attr.target.modal).to.be.calledWith @component.attr.defaults


      it 'bind on click opens', ->
        spy @component.container, 'on', =>
          spy @component, 'open', =>
            @component.initialize()
            expect(@component.container.on).to.be.calledWith('click')
            @component.container.trigger('click')
            expect(@component.open).to.be.called

      it 'does not open if login_required and user not loggedIn', ->
        @component.attr.login_required = true
        $.removeCookie 'logged_in'

        expect(@component.shouldOpen()).to.be.false

        spy @component.attr.target, "modal", =>
          @component.open()
          expect(@component.attr.target.modal).to.not.be.called


    describe 'remote modal', ->
      beforeEach ->
        @container = $ JST['templates/modal_remote']()
        @component = _base.startComponent 'modal', @container

      it 'has remote=true on attr', ->
        expect(@component.attr.remote).to.be.equal true

      it 'sets target to container', ->
        expect(@component.attr.target).to.be.deep.equal @component.container

      it 'start components with loaded DOM as root', ->
        sinon.spy App.mediator, 'publish'

        @component.afterOpen(null, {identifier: @component.identifier})
        @clock.tick(@component.attr.defaults.fadeDuration)

        args = App.mediator.publish.args[0]
        expect(args[0]).to.be.equal 'components:start'
        expect(args[1]).to.be.deep.equal $('.modal.current')

        App.mediator.publish.restore()

    describe 'autoload with prevent close', ->
      beforeEach ->
        @container = $ JST['templates/modal_autoload']()
        @component = _base.startComponent 'modal', @container

      it 'set attr', ->
        expect(@component.attr.autoload).to.be.equal true
        expect(@component.attr.prevent_close).to.be.equal true

      it 'sets target to container', ->
        expect(@component.attr.target).to.be.deep.equal @component.container

      it 'opens the target as a modal with prevent_close options', ->
        spy @component.attr.target, 'modal', =>
          expectedOptions = _.extend({}, @component.attr.defaults, @component.attr.preventCloseOpts)

          @component.open()
          expect(@component.attr.target.modal).to.be.calledWith expectedOptions

      it 'opens on initialize', ->
        spy @component, 'open', =>
          @component.initialize()
          expect(@component.open).to.be.called
