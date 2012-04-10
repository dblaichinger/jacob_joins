$ = jQuery

handleFieldValidation = (target) ->
  container = target.closest ".dirtyform"
  data = $(container).data "dirtyValidation"

  markAsValid target

  if target.val().length > 0 and target.val() isnt " "
    if target.attr("data-type") and not validateType(target)
      switch target.attr "data-type"
        when "email"
          error_message = "It has to be a valid email address."
        when "numerical"
          error_message = "It has to be a number."

      markAsInvalid target, error_message
  else
    markIfRequired target

  $(":input[data-required]", container).not(target).filter ->
    return $(this).val().length is 0 or $(this).val() is " "
  .each ->
    markIfRequired $(this)

  $(container).trigger "validated.dirtyValidation",
    valid: $("label.error", container).size() is 0

validateType = (input) ->
  switch input.attr "data-type"
    when "email"
      regex = /[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]/
      return regex.test input.val()
    when "numerical"
      return not isNaN input.val()

markAsInvalid = (field, error_message) ->
  data = field.closest(".dirtyform").data "dirtyValidation"
  field.addClass data.errorClass
  field.after '<label for="' + $(this).prop("id") + '" class="' + data.errorClass + '">' + error_message + '</label>'

markAsValid = (field) ->
  data = field.closest(".dirtyform").data "dirtyValidation"
  field.removeClass data.errorClass
  field.next().remove() if field.next().is "label.error"

markIfRequired = (field) ->
  markAsInvalid field, "This field is required." if field.attr("data-required") and not field.hasClass("error")

publicMethods =
  init: (options) ->
    this.each ->
      data = $(this).data "dirtyValidation"

      if not data
        settings = $.extend
          errorClass: "error"
        , options
        $(this).data "dirtyValidation", settings

        $(this).dirty_form({dynamic:true}).dirty (event, event_data) ->
          handleFieldValidation event_data.target

  destroy: ->
    this.each ->
      data = $(this).data "dirtyValidation"

      $(window).unbind ".dirtyValidation"
      $(this).removeData "dirtyValidation"

  validate: (field) ->
    data = $(this).data "dirtyValidation"

    if data
      handleFieldValidation field
    else
      console.debug "Can't validate form. Plugin not initialized."

$.fn.dirtyValidation = (method) ->
  if publicMethods[method]
    publicMethods[method].apply this, Array.prototype.slice.call arguments, 1
  else if typeof method is "object" or not method
    publicMethods.init.apply this, arguments
  else
    $.error "Method " +  method + " does not exist on jQuery.dirtyValidation"