$ ->
  $('#new_invoice_form').on 'click', '#period_group a', ->
    $('#period_group button').html($(this).html() + " <span class='caret'/>")
    $('#invoice_schedule_type').val($(this).html())
