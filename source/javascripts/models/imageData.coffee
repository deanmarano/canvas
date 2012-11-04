class App.Models.ImageData
  constructor: (imageData)->
    @imageData = imageData

  width: ->
    @imageData.width

  height: ->
    @imageData.height

  getAllPixels: ->
    pixels = []
    for row in [0...@imageData.height]
      for column in [0...@imageData.width]
        pixels.push(@getPixel(row, column))
    pixels


  eachPixel: (fn)->
    for pixel in @getAllPixels()
      @setPixel(fn.call(@, pixel))

  getPixel: (row, column, raiseError = true)->
    try
      @checkPixelBounds(row, column)
    catch e
      if raiseError
        throw e
      else
        row = 0 if row < 0
        column = 0 if column < 0
        row = @imageData.height if row > @imageData.height
        column = @imageData.width if column > @imageData.width
    data = @imageData.data
    pixelStart = @startValueForPixel(row, column)
    new App.Models.Pixel(
      data[pixelStart]
      data[pixelStart + 1]
      data[pixelStart + 2]
      data[pixelStart + 3]
      pixelStart
      row
      column
    )

  checkPixelBounds: (row, column)->
    throw "out of row bounds (got #{row} out of #{@imageData.height})" unless 0 <= row < @imageData.height
    throw "out of column bounds (got #{column} out of #{@imageData.width})" unless 0 <= column < @imageData.width

  startValueForPixel: (row, column)->
    (row * (@imageData.width * 4)) + (column * 4)

  setPixel: (pixel)->
    data = @imageData.data
    return unless pixel?
    pixel.start = @startValueForPixel(pixel.row, pixel.column) unless pixel.start?
    data[pixel.start] = pixel.red
    data[pixel.start + 1] = pixel.green
    data[pixel.start + 2] = pixel.blue
    data[pixel.start + 3] = pixel.alpha

  get3x3Neighborhood: (centerRow, centerColumn, size = 3)->
    result = @createSquareMatrix(size)
    result[0][0] = @getPixel(centerRow-1, centerColumn-1, false)
    result[0][1] = @getPixel(centerRow-1, centerColumn, false)
    result[0][2] = @getPixel(centerRow-1, centerColumn+1, false)
    result[1][0] = @getPixel(centerRow, centerColumn-1, false)
    result[1][1] = @getPixel(centerRow, centerColumn, false)
    result[1][2] = @getPixel(centerRow, centerColumn+1, false)
    result[2][0] = @getPixel(centerRow+1, centerColumn-1, false)
    result[2][1] = @getPixel(centerRow+1, centerColumn, false)
    result[2][2] = @getPixel(centerRow+1, centerColumn+1, false)
    result

  createSquareMatrix: (size)->
    matrix = []
    for row in [0...size]
      matrix[row] = []

  setNeighborhood: (neighborhood, values)->
    for row in [0...neighborhood.length]
      for column in [0...neighborhood[row].length]
        pixel = neighborhood[row][column]
        pixel.setAllValues(values[row][column])
        @setPixel(pixel)
