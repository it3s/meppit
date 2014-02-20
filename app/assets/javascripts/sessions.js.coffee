handle_ajax_error = (response) ->
  try
    responseText = JSON.parse(response.responseText);
  catch e
    responseText = null

  unless responseText is null
    responseText.error
  else
    'There was an unknown error or the request timed out.  Please try again later'

# REFACTOR extract to component (remote-form)
$ ->
  # callback for the ajax error on the #login form
  login_form = $('#login-form')

  login_form.on 'ajax:error', (el, response) ->
    login_form.find('.errors').remove()
    login_form.prepend("<p class='errors'>#{ handle_ajax_error(response) }</p>")

  login_form.on 'ajax:success', (el, response) ->
    window.location.href = response.redirect


