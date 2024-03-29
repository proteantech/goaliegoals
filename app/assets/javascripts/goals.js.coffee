# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(() ->
  $('.date-field').each( () ->
    $(this).datepicker({ dateFormat: 'yy-mm-dd' })
    return
  )
  $('.goal-edit-link').click( (eventObject) ->
    $(this).parents('.view-goal-table').hide()
    $(this).parents('.view-edit-pair').children('.edit-goal-form').show()
    $('.icon-pencil').css('visibility', 'hidden')
    return false
  )
  $('.goal-submit-link').click( (eventObject) ->
    $(this).parents('.edit-goal-form').submit()
    return
  )
  $('.goal-delete-link').click( (eventObject) ->
    r=confirm("Are you sure you want to delete this Goal?")
    if (r==true)
      $(this).closest('.view-edit-pair').find('.button_to').submit()
    return false
  )
  return
)