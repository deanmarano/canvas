class App.Models.ImageData
  constructor: (imageData)->
    @imageData = imageData
    @columns = imageData.width
    @rows = imageData.height

  data: ->
    @imageData.data

  getAllPixels: ->
    pixels = []
    for row in [0...@rows]
      for column in [0...@columns]
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
        row = @rows if row > @rows
        column = @columns if column > @columns
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

  getPaddedPixel: (row, column)->
    row = 0 if row < 0
    column = 0 if column < 0
    row = @rows if row > @rows
    column = @columns if column > @columns
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
    throw "out of row bounds (got #{row} out of #{@rows})" unless 0 <= row < @rows
    throw "out of column bounds (got #{column} out of #{@columns})" unless 0 <= column < @columns

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
    result[0][0] = @getPaddedPixel(centerRow-1, centerColumn-1)
    result[0][1] = @getPaddedPixel(centerRow-1, centerColumn)
    result[0][2] = @getPaddedPixel(centerRow-1, centerColumn+1)
    result[1][0] = @getPaddedPixel(centerRow, centerColumn-1)
    result[1][1] = @getPaddedPixel(centerRow, centerColumn)
    result[1][2] = @getPaddedPixel(centerRow, centerColumn+1)
    result[2][0] = @getPaddedPixel(centerRow+1, centerColumn-1)
    result[2][1] = @getPaddedPixel(centerRow+1, centerColumn)
    result[2][2] = @getPaddedPixel(centerRow+1, centerColumn+1)
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
