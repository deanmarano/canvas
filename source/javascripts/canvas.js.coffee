class window.Canvas
  constructor: ->
    _.extend(@, Backbone.Events)
    @canvas = document.getElementById("canvas")
    @context = @canvas.getContext('2d')
    @imgFunctions = new App.Lib.ImageFunctions

  loadImage: (imageUrl = 'images/kitten.png')->
    image = new Image()
    image.src = imageUrl
    $(image).load =>
      @onImageLoad(image)

  onImageLoad: (image)->
    @canvas.width = image.width
    @canvas.height = image.height
    @context.drawImage(image,
      0, #image start x
      0, #image start y
      image.width,
      image.height,
      0, #canvas start x
      0, #canvas start y
      @canvas.width,
      @canvas.height)
    @originalImage = @loadImageDataFromCanvas(image.width, image.height)
    @restore()

  cloneImage: (sourceData)->
    imageData = @context.createImageData(sourceData.width, sourceData.height)
    imageData.data.set(sourceData.data)
    new App.Models.ImageData(imageData)

  loadImageDataFromCanvas: (width, height)->
    @context.getImageData(0, 0, width, height)

  grayscaleByLuminosity: ->
    @callAndWrite(@imgFunctions.grayscaleByLuminosity)

  grayscaleByAverage: ->
    @callAndWrite(@imgFunctions.grayscaleByAverage)

  inverse: ->
    @callAndWrite(@imgFunctions.inverse)

  callAndWrite: (func) ->
    @imageData = func.call(@, @imageData)
    @writeImage(@imageData)

  blur: ->
    @imageData = @imgFunctions.blur(@imageData, @cloneImage(@imageData.imageData))
    @writeImage(@imageData)

  segmentImage: ->
    imageToRead = @imgFunctions.grayscaleByAverage(@imageData)
    imageToWrite = @cloneImage(@imageData.imageData)

    horizontallySegmentedImage = @imgFunctions.segmentHorizontal(imageToRead, imageToWrite)
    finalImage = @imgFunctions.segmentVertical(imageToRead, horizontallySegmentedImage)
    @writeImage(finalImage)

  segment: (bottom, top, newColor)->
    @imageData.eachPixel (pixel)->
      if pixel? && bottom < pixel.average().red < top
        pixel.setAllValues(newColor)
        @imageData.setPixel(pixel)
    @writeImage(@imageData)


  restore: ->
    @imageData = @cloneImage(@originalImage)
    @writeImage(@imageData)

  writeImage: (image)->
    @trigger('updated')
    @context.putImageData(image.imageData, 0, 0)
