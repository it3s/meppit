#= require spec_helper

describe 'modal', ->
  beforeEach ->
    @container = $ JST['templates/modal']()

  it 'defines modal component', ->
    expect(App.components.modal).to.not.be.undefined

  it 'initializes component', ->
    spy App.components, 'modal', =>
      App.mediator.publish 'components:start', @container
      expect(App.components.modal).to.be.called

  describe 'component', ->
    beforeEach ->
      container = @container.find('#modal-link')
      @component = App.components.modal container

    it 'has defaults', ->
      expect(@component.defaults).to.be.deep.equal {
        fadeDuration: 150
        zIndex: 200
      }

    it 'sets preventClose options', ->
      expect(@component.preventClose).to.be.deep.equal {
        escapeClose: false
        clickClose: false
        closeText: ''
        showClose: false
      }

    it 'calls start', ->
      spy @component, 'start', =>

        @component.init()
        expect(@component.start).to.be.called

    it 'retrieves json data', ->
      @component.init()
      expect(@component.data).to.be.deep.equal {test: true}

    it 'gets the referedElement', ->
      expect(@component.referedElement().selector).to.be.equal '#test'

    describe 'regular modal', ->
      it 'set target to referedElement', ->
        @component.init()
        expect(@component.target.selector).to.be.equal '#test'

      it 'opens the target as a modal with defaults', ->
        @component.init()

        spy @component.target, 'modal', =>
          @component.open(@component)
          expect(@component.target.modal).to.be.calledWith @component.defaults


      it 'bind on click starts', ->
        spy @component.container, 'on', =>
          spy @component, 'start', =>
            @component.init()
            expect(@component.container.on).to.be.calledWith('click')

            @component.container.trigger('click')
            expect(@component.start).to.be.called

    describe 'remote modal', ->
      beforeEach ->
        @container = $ JST['templates/modal_remote']()
        @component = App.components.modal @container

      it 'has remote=true on data', ->
        @component.init()
        expect(@component.data).to.be.deep.equal {remote: true}

      it 'sets target to container', ->
        @component.init()
        expect(@component.target).to.be.deep.equal @component.container

      it 'bind startComponents on ajax complete', ->
        spy @component.container, 'on', =>
          spy @component, 'startComponents', =>
            @component.init()
            expect(@component.container.on).to.be.calledWith 'modal:ajax:complete'

            @component.container.trigger 'modal:ajax:complete'
            expect(@component.startComponents).to.be.called


      it 'start components with loaded DOM as root', (done) ->
        sinon.spy App.mediator, 'publish'

        @component.init()
        @component.startComponents()
        setTimeout( ->
          args = App.mediator.publish.args[0]
          expect(args[0]).to.be.equal 'components:start'
          expect(args[1]).to.be.deep.equal $('.modal.current')

          App.mediator.publish.restore()
          done()
        , @component.fadeDuration)

    describe 'autoload with prevent close', ->
      beforeEach ->
        @container = $ JST['templates/modal_autoload']()
        @component = App.components.modal @container

      it 'set data', ->
        @component.init()
        expect(@component.data).to.be.deep.equal {autoload: true, prevent_close: true}

      it 'sets target to container', ->
        @component.init()
        expect(@component.target).to.be.deep.equal @component.container

      it 'opens the target as a modal with prevent_close options', ->
        @component.init()
        spy @component.target, 'modal', =>
          expectedOptions = _.extend({}, @component.defaults, @component.preventClose)

          @component.open(@component)
          expect(@component.target.modal).to.be.calledWith expectedOptions

      it 'opens on start', ->
        spy @component, 'open', =>
          @component.init()
          expect(@component.open).to.be.called






