class window.CharacterCanvas
  constructor: ->
    @canvas = document.getElementById("characterCanvas")
    @context = @canvas.getContext('2d')
    @imgFunctions = new App.Lib.ImageFunctions

  showImage: (image)->
    @image = image
    @writeImage()

  writeImage: ->
    @canvas.width = @image.width()
    @canvas.height = @image.height()
    @context.putImageData(@image.imageData, 0, 0)

  segmentVertical: ->
    imageToWrite = @cloneImage(@image)

    @image = @imgFunctions.segmentVertical(@image, imageToWrite)
    @writeImage()

  cloneImage: (sourceImage)->
    imageData = @context.createImageData(sourceImage.width(), sourceImage.height())
    imageData.data.set(sourceImage.data())
    new App.Models.ImageData(imageData)
