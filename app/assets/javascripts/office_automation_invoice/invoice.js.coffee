$ ->
  $('#period_group a').click ->
    $('#period_group button').html($(this).html() + " <span class='caret'/>")
    $('#invoice_schedule_type').val($(this).html())
