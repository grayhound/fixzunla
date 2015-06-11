$ ->

  $('#shortener_form_container').on('ajax:before', '#new_shortener_shortened_url', ->
    $('#new_shortener_shortened_url_ajax').show()
  ).on('ajax:complete', '#new_shortener_shortened_url', (xhr, status) ->
    $('#new_shortener_shortened_url_ajax').hide()
  ).on('ajax:success', '#new_shortener_shortened_url', (xhr, data, status) ->
    $('#shortener_form_container').html(data)
  )