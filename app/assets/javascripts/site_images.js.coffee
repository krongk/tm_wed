# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#the original style:
# jQuery -> 

# turbolinks style:
$(document).on 'ready page:load', ->
  count = 0
  $('#new_site_image').fileupload
    dataType: "script"

    # https://github.com/blueimp/jQuery-File-Upload/wiki/Client-side-Image-Resizing
    #没有成功
    disableImageResize: /Android(?!.*Chrome)|Opera/.test(window.navigator && navigator.userAgent)
    imageMaxWidth: 800
    imageMaxHeight: 1000
    imageCrop: true

    add: (e, data) ->
      types = /(\.|\/)(gif|jpe?g|png)$/i
      file = data.files[0]

      if file.size > 4000000
        alert("#{file.name} 大于4MB，无法上传到服务器，请通过图片压缩软件压缩后再上传.")
        return
      if count > 20
        alert("维斗喜帖允许最多上传20张照片，以避免应用打开速度过慢.")
        return
      if types.test(file.type) || types.test(file.name)
        $('#upload-help').hide()
        data.context = $(tmpl("template-upload", file))
        $('#updating').append(data.context)
        $('#current-select').html("已上传照片："+ count += 1);
        data.submit()
      else
        alert("#{file.name} 文件格式错误，允许上传的文件格式为:gif/jpg/jpeg/png.")
    progress: (e, data) ->
      if data.context
        progress = parseInt(data.loaded / data.total * 100, 10)
        data.context.find('.bar').css('width', progress + '%')

  #for sortable
  $('#site_images').sortable
    axis: 'y'
    handle: '.handle'
    update: ->
      $.post($(this).data('update-url'), $(this).sortable('serialize'))
