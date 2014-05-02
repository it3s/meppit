## Overlay

translucid layer for disabling elements

### markup

```
<div data-components="overlay">
  My content to be disabled
</div>
```

### with message

shows a message centered on the overlay

```
<div data-components="overlay" data-overlay='<%= {:message => t("some.message")}.to_json %>' >
  My content to be disabled
</div>
```

### dark overlay

same as before but with a black-ish translucid layer

```
<div data-components="overlay" data-overlay='<%= {:style => "dark", :message => t("some.message")}.to_json %>' >
  My content to be disabled
</div>
```

