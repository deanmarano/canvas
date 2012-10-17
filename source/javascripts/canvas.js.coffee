class window.Canvas
  constructor: ->
    _.extend(@, Backbone.Events)
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
      0, #canvas start x
      0, #canvas start y
      @canvas.width,
      @canvas.height)
    @originalImage = @loadImageDataFromCanvas(image.width, image.height)
    @restore()

  cloneImage: (sourceData)->
    imageData = @context.createImageData(sourceData.width, sourceData.height)
    imageData.data.set(sourceData.data)
    imageData

  loadImageDataFromCanvas: (width, height)->
    @context.getImageData(0, 0, width, height)

  checkPixelBounds: (row, column)->
    throw "out of row bounds (got #{row} out of #{@imageData.height})" unless 0 <= row < @imageData.height
    throw "out of column bounds (got #{column} out of #{@imageData.width})" unless 0 <= column < @imageData.width

  getPixel: (row, column, raiseError = true)->
    try
      @checkPixelBounds(row, column)
    catch e
      if raiseError
        throw e
      else
        return null
    data = @imageData.data
    pixelStart = @startValueForPixel(row, column)
    new App.Models.Pixel(
      data[pixelStart]
      data[pixelStart + 1]
      data[pixelStart + 2]
      data[pixelStart + 3]
      pixelStart)

  get3x3Neighborhood: (centerRow, centerColumn)->
    result = [[], [], []]
    result[0][0] = @getPixel(centerRow-1, centerColumn-1, false)
    result[0][1] = @getPixel(centerRow-1, centerColumn, false)
    result[0][2] = @getPixel(centerRow-1, centerColumn+1, false)
    result[1][0] = @getPixel(centerRow, centerColumn-1, false)
    result[1][1] = @getPixel(centerRow, centerColumn, false)
    result[1][2] = @getPixel(centerRow, centerColumn+1, false)
    result[2][0] = @getPixel(centerRow+1, centerColumn-1, false)
    result[2][1] = @getPixel(centerRow+1, centerColumn, false)
    result[2][2] = @getPixel(centerRow+1, centerColumn+1, false)

    if centerRow == 0
      result[0][0] = result[1][0]
      result[0][1] = result[1][1]
      result[0][2] = result[1][1]
    if centerRow == @imageData.height - 1
      result[2][0] = result[1][0]
      result[2][1] = result[1][1]
      result[2][2] = result[1][1]
    if centerColumn == 0
      result[0][0] = result[0][1]
      result[1][0] = result[1][1]
      result[2][0] = result[2][1]
    if centerColumn == @imageData.width - 1
      result[0][2] = result[0][1]
      result[1][2] = result[1][1]
      result[2][2] = result[2][1]

    result

  startValueForPixel: (row, column)->
    (row * (@imageData.width * 4)) + (column * 4)

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

  gaussian: ->
    for row in [0...@imageData.height]
      for column in [0...@imageData.width]
        neighborhood = @get3x3Neighborhood(row, column)
        values = _.flatten(neighborhood)
        mean = _.reduce(values, (sum, pixel)->
          sum + pixel.red
        , 0) / values.length
        pixelOfInterest = neighborhood[1][1]
        pixelOfInterest.gaussian(mean)
        console.log row*@imageData.height + column
    @writeImage()

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
    @trigger('updated')
    @context.putImageData(@imageData, 0, 0)
