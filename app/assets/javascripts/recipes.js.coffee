window.publish_recipe = (id, user_location) ->
  return_value = false

  $.ajax
    url: "recipes/draft"
    type: "POST"
    async: false
    data:
      _method: "PUT"
      user_id: id
      location: user_location

    success: (data, textStatus, jqXHR) ->
      return_value = data

    statusCode:
      304: ->
        return_value = false

      400: ->
        return_value = false

      500: ->
        return_value = false

  return_value


window.prepare_recipe_step_upload = (currentFileInput) ->
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
      $(this).addClass "changed"

    add: (e, data) ->
      data.submit()
    fail: (e, data) ->
      alert "fail"

window.prepare_recipe_uploads = () ->
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
        $(":input", uploadWrapper).addClass "changed"
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
      data.htmlElement.html('<img src="' + data.result[0].thumbnail_url + '" alt="' + data.result[0].name + '"><a href="' + data.result[0].delete_url + '" class="delete">delete</a>')
      $(this).addClass "changed"

    fail: (e, data) ->
      alert 'Upload of "' + data.files[0].name + '" failed!'

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
        $(":input", "#recipe_images").addClass "changed"

      failure: (jqXHR, textStatus, errorThrown) ->
        alert 'Image delete failed!'
    false