# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(() ->
  $('.date-field').each( () ->
    $(this).datepicker({ dateFormat: 'yy-mm-dd' })
    return
  )
  $('.edit-goal-link').click( (eventObject) ->
    $(this).parents('.view-goal-table').hide()
    $(this).parents('.view-edit-pair').children('.edit-goal-form').show()
    $('.icon-pencil').hide()
    return false
  )
  $('.goal-submit-link').click( (eventObject) ->
    $(this).parents('.edit-goal-form').submit()
    return
  )
  return
)