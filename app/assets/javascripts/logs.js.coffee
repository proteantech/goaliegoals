# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(() ->
  $('.date-field').each( () ->
    $(this).datepicker({ dateFormat: 'yy-mm-dd' })
    return
  )
  $('.edit-log-link').click( (eventObject) ->
    $(this).parents('.view-log-table').hide()
    $(this).parents('.log-pair').children('.edit-log-form').show()
    $('.icon-pencil').hide()
    return false
  )
  $('.log-submit-link').click( (eventObject) ->
    $(this).parents('.edit-log-form').submit()
    return
  )
  return
)