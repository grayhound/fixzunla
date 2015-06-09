$ ->
  $('#new_shortener_shortened_url').on('ajax:before', ->
    $('#new_shortener_shortened_url_ajax').show()
  ).on('ajax:complete', (xhr, status) ->
    $('#new_shortener_shortened_url_ajax').hide()
  ).on('ajax:success', (xhr, data, status) ->
    $('#shortener_form_container').html(data)
  )