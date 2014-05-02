## RemoteForm

send and validate forms remotely (xhr)

### markup

```
<%= form_tag do_login_url, :method => :post,
                           :id => 'login-form',
                           :remote => true,
                           'data-components' => 'remoteForm' do %>
  <p>
    <%= label_tag :email, t('sessions.form.login.email') %>
    <%= email_field_tag :email %>
  </p>
  <p>
    <%= label_tag :password, t('sessions.form.login.password') %>
    <%= password_field_tag :password %>
  </p>

  <p>
    <%= submit_tag t('sessions.form.login.submit') %>
  </p>
<% end %>
```

### Controller

- Success: return an redirect url (if you want to be redirected)
- Error: send json with errors (status must be :unprocessable_entity)

```
def action
  # whatever
  if saved
    render :json => { :redirect => some_url }
  else
    render :json => { :errors => @obj.errors.messages }, :status => :unprocessable_entity
  end
end
```

