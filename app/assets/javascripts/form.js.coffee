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

prepare_csi_slider = () ->
  csi_slider = $('#csi_slider').bxSlider
    pager: true
    infiniteLoop: false
    hideControlOnEnd: true
    mode: 'fade'
  $('#csi_slider_navigation').on "click", "a", (e) ->
    csi_slider.goToSlide $('#csi_slider_navigation a').index(this)
    false

window.reinitialize_tooltips = (context) ->
  $("[data-tooltip]", context).each ->
    $(this).qtip
      overwrite: false
      content:
        text: $(this).attr "data-tooltip"
      position:
        my: "bottom left"
        at: "top center"
        target: $(this)
    .qtip('option', 'content.text', $(this).attr("data-tooltip"))

$ ->
  $(".scroll").click ->
    $("#newsbar").visibleAfter "destroy"
    $.scrollTo $('#story_1'), 800,
      onAfter: ->
        $("#newsbar").visibleAfter $("#start")
        element.fadeIn 50

  $("#wizard").on 'click', "#send", (e) ->
    event.preventDefault()

    if $(this).hasClass("disabled")
      return false

    unless window.user?
      if $('#aboutyou').parent().hasClass('form_valid')
        empty_user_form = publish_user()
        
        window.user = 
          id: $('#user_tab form').attr('action').split('/')[2]
          location:
            longitude: $('#longitude').val()
            latitude: $('#latitude').val()
            city: $('#city_hidden').val()
            country: $('#country_hidden').val()
            
    if window.user
      empty_recipe_form = publish_recipe(window.user.id, window.user.location) if $('#yourrecipe').parent().hasClass('form_valid')
      empty_csi_form = publish_csi(window.user.id, window.user.location) if $('#aboutyourcountry').parent().hasClass('form_valid')

      if empty_recipe_form or empty_csi_form
        $.ajax
          url: "/pages/drafts_saved"
          success: (data, textStatus, jqXHR) ->
            if empty_recipe_form?
              $('#recipe_tab').html(empty_recipe_form)
              prepare_recipe_uploads()
              $('#yourrecipe').parent().removeClass('form_valid')

            if empty_csi_form?
              $('#country_specific_information_tab').html(empty_csi_form) 
              prepare_csi_slider()
              $('#aboutyourcountry').parent().removeClass('form_valid')

            if empty_user_form?
              $('#user_tab').html(empty_user_form)
              prepare_user_map()
              $('#aboutyou').parent().removeClass('form_valid')

            $('#preview_tab').html(data)
            $.scrollTo "#wizard", 800
              offset:
                top: -70

          error: (jqXHR, textStatus, errorThrown) ->
            alert "Error loading success page!"

      else
        alert "Failed to save the draft(s)!"
    else
      alert "Unable to save user information (maybe not provided)."

  $("#wizard").bind "validated.dirtyValidation", (event, data) ->
    tabs = $(".dirtyform", "#wizard")

    index = tabs.index $(event.target)
    referring_link = $($(".ui-state-default", ".ui-tabs-nav")[index])

    if data.valid
      referring_link.removeClass("form_not_valid").addClass("form_valid")
    else
      referring_link.removeClass("form_valid").addClass("form_not_valid")

  $('#wizard').tabs()

  $('#wizard').bind 'tabsshow', (event, ui) ->
    $(".error", ui.panel).qtip "show"
    $(":input", ui.panel).filter (index) ->
      return $(this).attr("visibility") isnt "hidden"
    .parent().qtip "show"

  $('#wizard').bind 'tabsselect', (event, ui) ->
    newHash = "#!/form/#{ui.tab.hash.slice 1}"
    window.location.hash = newHash if window.location.hash isnt newHash

    oldTabIndex = $('#wizard').tabs 'option', 'selected'
    oldTab = $('.ui-tabs-panel:not(.ui-tabs-hide)')

    $("[aria-describedby]", oldTab).qtip "hide"

    if oldTabIndex < $('#wizard').tabs('length') and oldTab.find(":input").hasClass("changed")
      url = oldTab.attr('id').replace '_tab', 's/sync_wizard'
      params = oldTab.children('form').serializeArray()

      actual_form = oldTab.find("form")
      actual_nav_link = $('.ui-state-active')

      $.ajax
        url: url
        type: 'POST'
        async: false
        data: params
        success: (data, textStatus, jqXHR) ->
          oldTab.html data
          $(".dirtyform", oldTab).dirtyValidation "validate", $(":input", oldTab).not("[type='hidden']")

          reinitialize_tooltips oldTab

          oldTab.css
            display: "block"
          oldTab.attr "style", ""

          switch oldTab.attr('id')
            when "recipe_tab"
              prepare_recipe_uploads()
            when "country_specific_information_tab"
              prepare_csi_slider()
            when "user_tab"
              prepare_user_map()         
        statusCode:
          400: ->
            console.log "Unable to save changes"

    if ui.index is $('#wizard').tabs('length') - 1
      #TODO: ajax loader einbauen
      $.get "pages/preview", (data, textStatus) ->
        #TODO: ajax loader ausblenden
        $('#preview_tab').html(data)

        if $('#aboutyou').partent().hasClass('form_valid') and ( $('#yourrecipe').parent().hasClass('form_valid') or $('#aboutyourcountry').parent().hasClass('form_valid') )
          $('#send').removeClass('disabled')

  prepare_recipe_uploads()
  prepare_csi_slider()
  prepare_user_map()
