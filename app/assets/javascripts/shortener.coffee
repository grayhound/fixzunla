$ ->
  shortenerList = ->
    list_container = $('#shortener_urls_list_container')
    return false if list_container.length == 0
    list_url = list_container.attr('_url')
    $.get list_url, (data) ->
      list_container.html(data)

  $('#shortener_form_container').on('ajax:before', '#new_shortener_shortened_url', ->
    $('#new_shortener_shortened_url_ajax').show()
    $('#shortener_form_container > .form_errors').hide()
  ).on('ajax:complete', '#new_shortener_shortened_url', (xhr, status) ->
    $('#new_shortener_shortened_url_ajax').hide()
  ).on('ajax:success', '#new_shortener_shortened_url', (xhr, data, status) ->
    $('#shortener_form_container').html(data)
    shortenerList()
  )

  shortenerList()