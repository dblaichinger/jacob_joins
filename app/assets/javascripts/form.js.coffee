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

  wizard_tabs = $('#wizard').tabs()

  $('#wizard').bind 'tabsselect', (event, ui) ->

    oldTabIndex = $('#wizard').tabs 'option', 'selected'
    oldTab = $('.ui-tabs-panel:not(.ui-tabs-hide)')

    if oldTabIndex < $('#wizard').tabs('length') - 1
      url = oldTab.attr('id').replace '_tab', 's/sync_wizard'
      params = oldTab.children('form').serializeArray()

      actual_form = oldTab.find("form")

      input_fields = $(actual_form).find('input:text')
      validation = false
      $.each input_fields, (index, field) ->
        # Check if it's not a hidden field, built by Rails. Second check if a value is inserted and third check if it's not the prefilled ingredients
        if !($(field).is(':hidden')) && ($(field).val().length > 0) && !($(field).attr("id").indexOf("recipe_ingredients") >=0)
          console.debug("this one!")
          validation = true

      console.debug("val:" +validation)
      if validation == true
        $.ajax
          url: url
          beforeSend: () ->
            return validate_form(actual_form)
          type: 'POST'
          data: params
          success: (data, textStatus, jqXHR) ->
            oldTab.html(data)

            switch oldTab.attr('id')
              when "recipe_tab"
                prepare_recipe_uploads()
              when "country_specific_information_tab"
                prepare_csi_slider()

            newHash = '#!/form/' + ui.tab.hash.slice(1)
            if window.location.hash != newHash
              window.location.hash = newHash

        true


  # --- recipe -------------------------------------------------
  prepare_recipe_uploads()

  # --- csi ----------------------------------------------
  prepare_csi_slider()

validate_form = (form) ->
  validator = form.validate
    debug: true
    onsubmit: false
    sucess: "valid"

  return form.valid()

