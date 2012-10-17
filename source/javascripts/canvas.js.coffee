class window.Canvas
  constructor: ->
    @canvas = document.getElementById("canvas")
    @context = @canvas.getContext('2d')

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
      0, #canvas.start x
      0, #canvas.start y
      @canvas.width,
      @canvas.height)
    @originalImage = @loadImageDataFromCanvas(image.width, image.height)
    @restore()

  cloneImage: (sourceData)->
    dst = @context.createImageData(sourceData.width, sourceData.height)
    dst.data.set(sourceData.data)
    dst

  loadImageDataFromCanvas: (width, height)->
    @context.getImageData(0, 0, width, height)

  checkPixelBounds: (row, column)->
    throw "out of row bounds (got #{row} out of #{@imageData.height})" if row >= @imageData.height
    throw "out of column bounds (got #{column} out of #{@imageData.width})" if column >= @imageData.width

  getPixel: (row, column)->
    @checkPixelBounds(row, column)
    data = @imageData.data
    pixelStart = @startValueForPixel(row, column)
    new App.Models.Pixel(
      data[pixelStart]
      data[pixelStart + 1]
      data[pixelStart + 2]
      data[pixelStart+ 3]
      pixelStart)

  startValueForPixel: (row, column)->
    ((row) * (@imageData.width * 4)) + ((column) * 4)

  getAllPixels: ->
    pixels = []
    for row in [0...@imageData.height]
      for column in [0...@imageData.width]
        pixels.push(@getPixel(row, column))
    pixels

  setPixel: (pixel)->
    data = @imageData.data
    data[pixel.start] = pixel.red
    data[pixel.start + 1] = pixel.green
    data[pixel.start + 2] = pixel.blue
    data[pixel.start + 3] = pixel.alpha

  inverse: ->
    @eachPixel (pixel)->
      pixel.inverse()

  grayscaleByAverage: ->
    @eachPixel (pixel)->
      pixel.average()

  grayscaleByLuminosity: ->
    @eachPixel (pixel)->
      pixel.averageLuminosity()

  eachPixel: (fn)->
    for pixel in @getAllPixels()
      @setPixel(fn.call(@, pixel))
    @writeImage()

  restore: ->
    @imageData = @cloneImage(@originalImage)
    @writeImage()

  writeImage: ()->
    @context.putImageData(@imageData, 0, 0)
