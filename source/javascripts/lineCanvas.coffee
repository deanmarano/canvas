class window.LineCanvas
  constructor: ->
    @canvas = document.getElementById("lineCanvas")
    @context = @canvas.getContext('2d')
    @imgFunctions = new App.Lib.ImageFunctions(@context)

  showImage: (image)->
    @lastFoundCharacter = 0
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

  findNextCharacter: ->
    column = @lastFoundCharacter || 0
    while @image.getPixel(0, column).red == 0
      column = column + 1
    left = column
    while @image.getPixel(0, column).red != 0
      column = column + 1
    right = column
    @lastFoundCharacter = right
    @imgFunctions.getSegment(@image, 0, left, @image.height(), right)
