class window.CharacterCanvas
  constructor: ->
    @canvas = document.getElementById("characterCanvas")
    @context = @canvas.getContext('2d')
    @imgFunctions = new App.Lib.ImageFunctions

  showImage: (image)->
    @image = image
    @writeImage()

  writeImage: ->
    @canvas.width = @image.columns
    @canvas.height = @image.rows
    @context.putImageData(@image.imageData, 0, 0)

  segmentVertical: ->
    imageToWrite = @imgFunctions.cloneImage(@image)

    @image = @imgFunctions.segmentVertical(@image, imageToWrite)
    @writeImage()
