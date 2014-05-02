## Styling

### Sprites and images

- for sprites we use compass sprites

- for large images use Rails normal image_tag

- for smaller images use the `sprite-image` mixin

```
# given the image is inside the icons folder
<span class="my-img"></span>

.my-img { @include sprite-image($icons-map, image-name); }
```

- For application-wide common icons we use font-awesome svg icons.

```
 <%= icon icon_name, '', :class => "fa-lg fa-fw" %>
```

### Mixins

- meppit-box-shadow : box shadown already styled with meppit colors

- button : meppit button with gradient

- modal :  to use with the modal component

- sprite-image : replace small images with sprites


### reusblebles

- .button

- .left-pane  => lateral pane

- .wrapper  => cleafirx wrapping div

- .overlay  => to use with overlay components

- take a look at the `settings.scss.css` file for common colors and fonts definitions
