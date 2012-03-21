$ ->
  $('#wizard').tabs()
  $('#wizard').bind 'tabsselect', (event, ui) ->
    oldTabIndex = $('#wizard').tabs 'option', 'selected'
    oldTab = $('.ui-tabs-panel:not(.ui-tabs-hide)')

    if oldTabIndex < $('#wizard').tabs('length') - 1
      url = oldTab.attr('id').replace '_tab', 's/sync_wizard'
      console.log url
      console.log oldTab
      params = oldTab.children('form').serialize()
      console.log params

      $.ajax
        url: url
        type: 'POST'
        data: params

  # --- recipe -------------------------------------------------
  $('.steps .step input[type="file"]').each (index) ->
    currentFileInput = $(this)
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
        console.log data
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
      ###submit: (e, data) ->
        console.log "submit"
        #console.log data.formData###
      fail: (e, data) ->
        console.log "fail"
      ###always: (e, data) ->
        console.log "always"###

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
      console.log "success"
      console.log data

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

  # --- csi ----------------------------------------------
