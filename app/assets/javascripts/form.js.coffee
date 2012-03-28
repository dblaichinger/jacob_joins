prepare_recipe_step_upload = (currentFileInput) ->
  currentFileInput.fileupload
    dataType: 'json'
    url: '/recipes/upload_step_image'
    formData: (form) ->
      stepIdInputId = currentFileInput.attr('id').replace 'image', 'id'
      stepIdInputElement = form.find('#' + stepIdInputId)
      data = [
        name: "authenticity_token"
        value: form.find('input[name="authenticity_token"]').attr('value')
      ]

      if stepIdInputElement.length > 0
        data.push 
          name: stepIdInputElement.attr 'name'
          value: stepIdInputElement.attr 'value'
      data

    done: (e, data) ->
      image = data.result[0]
      stepIdInputId = currentFileInput.attr('id').replace 'image', 'id'
      stepIdInputName = currentFileInput.attr('name').replace 'image', 'id'
      uploadWrapper = $('#' + currentFileInput.attr('id')).parent()
      stepIdInputElement = uploadWrapper.prev('#' + stepIdInputId)

      uploadWrapper.css
        display: 'none'

      if stepIdInputElement.length == 0
        uploadWrapper.before '<input type="hidden" id="' + stepIdInputId + '" name="' + stepIdInputName + '" value="' + image.step_id + '">'

      uploadWrapper.after '<div class="image_preview"><img src="' + image.thumbnail_url + '" alt="' + image.name + '"><a href="' + image.delete_url + '" class="delete">delete</a></div>'

    add: (e, data) ->
      data.submit()
    fail: (e, data) ->
      alert "fail"
    #submit: (e, data) ->
    #always: (e, data) ->

prepare_recipe_uploads = () ->
  $('.steps .step input[type="file"]').each (index) ->
    prepare_recipe_step_upload $(this)

  $('.step').on 'click', 'a.delete', (e) ->
    clicked_link = $(this)
    $.ajax
      url: clicked_link.attr('href')
      type: 'POST'
      data:
        _method: "DELETE"
      success: (data, textStatus, jqXHR) ->
        imagePreview = clicked_link.parent()
        uploadWrapper = imagePreview.prev('.upload_wrapper')

        uploadWrapper.css
          display: 'block'

        imagePreview.remove()
      failure: (jqXHR, textStatus, errorThrown) ->
        alert 'Image delete failed!'
    false

  $('#recipe_images input[type="file"]').fileupload
    url: '/recipes/upload_image'
    type: 'POST'
    formData: (form) ->
      [
        name: "authenticity_token"
        value: form.find('input[name="authenticity_token"]').attr('value')
      ]
    done: (e, data) ->
      data.htmlElement.prepend('<img src="' + data.result[0].thumbnail_url + '" alt="' + data.result[0].name + '">')
      data.htmlElement.append('<a href="' + data.result[0].delete_url + '" class="delete">delete</a>')
      data.htmlElement.css
        backgroundColor: '#0f0'

    fail: (e, data) ->
      alert 'Upload of "' + data.files[0].name + '" failed!'
      data.htmlElement.css
        backgroundColor: 'red'

    add: (e, data) ->
      $('ul.file_uploads').prepend (index, html) ->
        file = $('<li>' + data.files[0].name + '</li>')
        data.htmlElement = file
        file

      data.submit()

  $('ul.file_uploads').on 'click', 'a.delete', (e) ->
    clicked_link = $(this)
    $.ajax
      url: clicked_link.attr('href')
      type: 'POST'
      data:
        _method: "DELETE"
      success: (data, textStatus, jqXHR) ->
        clicked_link.parent('li').remove()
      failure: (jqXHR, textStatus, errorThrown) ->
        alert 'Image delete failed!'
    false

prepare_csi_slider = () ->
  csi_slider = $('#csi_slider').bxSlider
    pager: true
    infiniteLoop: false
    hideControlOnEnd: true
    mode: 'fade'
  $('#csi_slider_navigation').on "click", "a", (e) ->
    csi_slider.goToSlide $('#csi_slider_navigation a').index(this)
    false

$ ->
  elementTemplate = c = $('#recipe_tab .steps .step:last').clone(true, true)
  elementTemplate.children('.image_preview').remove()
  elementTemplate.children('input[type="hidden"]').remove()
  elementTemplate.children('.upload_wrapper').css
    display: 'block'
  elementTemplate = $('<div>').append(elementTemplate).html()

  $('#recipe_tab .steps').elementOnDemand
    element: elementTemplate
    onAddElement: (context) ->
      count = $(this).siblings('.step').length + 1
      $(this).find('label[for=*"description"] span').html(count)
      prepare_recipe_step_upload $(this).find('input[type="file"]:first')

  $("#wizard #send").click ->
      user_info = publish_user();

      if user_info
        recipe = publish_recipe user_info.user_id, user_info.location
        csi = publish_csi user_info.location
        
        if recipe and csi
          alert "Your drafts were saved successfully"
      else
        alert "Saving the drafts failed"

  $('#wizard').tabs()
  $('#wizard').bind 'tabsselect', (event, ui) ->
    newHash = '#!/form/' + ui.tab.hash.slice(1)
    if window.location.hash != newHash
      window.location.hash = newHash

    oldTabIndex = $('#wizard').tabs 'option', 'selected'
    oldTab = $('.ui-tabs-panel:not(.ui-tabs-hide)')

    if oldTabIndex < $('#wizard').tabs('length') - 1
      url = oldTab.attr('id').replace '_tab', 's/sync_wizard'
      params = oldTab.children('form').serializeArray()

      actual_form = oldTab.find("form")
      actual_nav_link = $('.ui-state-active')

      input_fields = $(actual_form).find('input:text')
      validation = false
      $.each input_fields, (index, field) ->
        # Check if it's not a hidden field, built by Rails. Second check if a value is inserted and third check if it's not the prefilled ingredients
        if !($(field).is(':hidden')) && ($(field).val().length > 0) && !($(field).attr("id").indexOf("recipe_ingredients") >=0)
          validation = true

      if validation == true
        $.ajax
          url: url
          beforeSend: ()->
            if oldTab.attr("id") == "user_tab"
              getLatLngFromAddress()
          type: 'POST'
          data: params
          success: (data, textStatus, jqXHR) ->
            oldTab.html data

            oldTab.css
              display: "block"
            validate_form(oldTab.find("form"), actual_nav_link)
            oldTab.attr("style", "")

            switch oldTab.attr('id')
              when "recipe_tab"
                prepare_recipe_uploads()
              when "country_specific_information_tab"
                prepare_csi_slider()            
          statusCode:
            400: ->
              console.log "Unable to save changes"
            200: ->
              if ui.index is $('#wizard').tabs('length') - 1
                $.get "recipes/draft", (data, textStatus) ->
                  if textStatus is "Gone"
                    return
                    
                  $("#preview_tab .recipe").empty()
                  $(data).appendTo $("#preview_tab .recipe")

                $.get "country_specific_informations/draft", (data, textStatus) ->
                  if textStatus is "Gone"
                    return
                    
                  $("#preview_tab .csi").empty()
                  $(data).appendTo $("#preview_tab .csi")

  # --- recipe -------------------------------------------------
  prepare_recipe_uploads()

  # --- csi ----------------------------------------------
  prepare_csi_slider()

validate_form = (form, nav_link) ->
  validator = form.validate
    debug: true
    onsubmit: false
    sucess: "valid"

  if form.valid()
    nav_link.removeClass("form_not_valid")
    nav_link.addClass("form_valid")
  else
    nav_link.removeClass("form_valid")
    nav_link.addClass("form_not_valid")

  return form.valid()

