## Js Components

For adding any js behavior we use an "auto-loading component" pattern.

We have a global `App.mediator` pub/sub object. So always use async events to coordinate behavior among components.

When a event "components:start" is triggered (passing an optional root node), all components on that root tree will be loaded.

### App.mediator

```
publish(channel, data)  # emit an event with the given data
subscribe(channel, fn)  # subscribe to the given channel, and call the callback function (which receives data)
unsubscribe(channel)    # stop listening to that channel
```

### App.components

```
App.components._instances  # an hash which holds all started components instances, the key is either the container id or a 'random' generated id
App.components             # object with the component factories
```


## Creating a component

### markup

A component is an html container with a `data-components` attributes. The components refered on this attr, will be initialized for that container.
You can pass an json object with options to the components with the `data-<component-name-in-lowercase>-options` attribute, the object will be available on `@attr` inside the component. E.g:

```
<div id="my-ui-component" data-components="component1 component2" data-component1-options='{"some":"json"}' ></div>

# will call the factories for component1 and component2 passing the #my-ui-component container as argument
```

### js

An js component is a factory with the following structure:

```
App.components.component1 =->
  initialize: ->
     # this is the initialization function, called when the component is started

  # ... any methods you want

```

For passing data for the component use the `data-<lowercase-name>-options` atrributes. I.e:

```
<div data-components="myComponent" data-mycomponent-options='<%= {:key1 => "value" }.to_json %>'></div>

App.components.myComponent = ->
  initialize: ->
    console.log @attr.key1 # = "value"

```

You can extend the attribute with the `attributes` method. E.g:

```
# With the same html as above
App.components.myComponent = ->
  attributes: ->
    field: @container.find('.my-field')
    key1: @attr.key1 || 'default'

  initialize: ->
    console.log @attr.key1 # = "value" (or 'default' if not present on options)
    console.log @attr.field  # the selected field on attributes

```

Another convenience method is the `@on` for event binding.

```
# instead this
@container.on 'click', @myCallback.bind(this)

# do this
@on 'click', @myCallback


# instead this
@attr.field 'change', @cb.bind(this)

# do this
@on @attr.field, 'change', @cb
```

You can pass either a `evt-string` and a `calback` to events on `@container`.
Or, `selectedNode`, `evt-string` and `callcack` to event on any other node.

## Event

Always use the `App.mediator` for communicating bettwen components. Every component
has a `@identifier` with a unique id of type "<component>:<id>", where the is either
the html id, or href or an ramdom key.
So for a modal with id "login-form" => `@identifier == 'modal:login-form'

## Remarks

- add an asset-pipeline dependencie for (only) an component, on its own file. E.g:

```
# uploader.js.coffee

#= require 'jquery-fileupload'

App.components.uploader = -> ...
```

- avoid 'class', 'new' and mutating state, as much as possible. Try to write a more "functional" javascript, always use small functions and message passing. For creating objects use a factory pattern (like you saw on components).


