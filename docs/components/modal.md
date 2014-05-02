## Modal

modal content

### markup

with the helper
```
<%= link_to_modal "link", ref, options %>

// ref: id or url
```

pure html
```
<a href="ref" data-components="modal" data-modal='{"options": "goes here"}'/>
```

### modal with html element

```
// html.erb

<%= link_to_modal "link", "#modal-id" %>

<div id="modal-id" >
  modal content
</div>


// scss

#modal-id {
  @include modal;
}
```

### modal via ajax

```
// html.erb
<%= link_to_modal 'link', action_path, :remote => true %>

// controller
def action
  render :layout => nil if request.xhr?  # render template without layout
end
```

### autoloaded and/or unclosable modal

```
// html.erb
<div id="my-modal"
         data-components="modal"
         data-modal="<%= {:autoload => true, :prevent_close => true }.to_json %>" >
  CONTENT
</div>

// scss
#my-modal { @include modal; }
```

### Options

```
:html => {:attr => "bla"}  # html attributes

other options are passed to modal via `data-modal`:

:prevent_close => default false  # prevent modal from being closed
:auto_load => default false      # auto open modal
:remote => default false         # loads modal content via ajax
```

OBS: when the modal content is loaded remotely, it starts all components inside the modal.

