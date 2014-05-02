## Editor

markdown textarea editor (uses tinyMCE)

### markup

```
<%= f.input :about_me, :as => :text, :input_html => {:class => 'tinymce', 'data-components' => 'editor'} %>

OR

<textarea id="obj_about_me" name="obj[about_me]" data-components="editor" class="tinymce" ></textarea
```

OBS: retrieves the locale from body, i.e : `<body locale="pt_BR"> ... </body>`
