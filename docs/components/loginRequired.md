## loginRequired

intercept links and modals, when user is not logged in, and opens login modal.

### Markup

- with links:

```
<a href="/top-secret-page" data-components="loginRequired"></a>
```

- with modals:

```
<%= link_to_modal "my-link", "#modal-id", login_required: true %>

```
