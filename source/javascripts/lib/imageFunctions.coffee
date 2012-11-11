class App.Lib.ImageFunctions
  constructor: (context)->
    @context = context
    _.extend(@, Colors)

  cloneImage: (sourceImage)->
    imageData = @context.createImageData(sourceImage.columns, sourceImage.rows)
    imageData.data.set(sourceImage.data())
    new App.Models.ImageData(imageData)

  inverse: (image)->
    image.eachPixel (pixel)->
      pixel.inverse()
    image

  grayscaleByAverage: (image)->
    image.eachPixel (pixel)->
      pixel.average()
    image

  grayscaleByLuminosity: (image)->
    image.eachPixel (pixel)->
      pixel.averageLuminosity()
    image

  blur: (imageToRead)->
    imageToWrite = @cloneImage(imageToRead)
    imageToRead.eachPixel (pixel)=>
      neighborhood = imageToRead.get3x3Neighborhood(pixel.row, pixel.column)
      pixel.average()
      values = _.flatten(neighborhood)
      mean = (values[0].red + values[1].red + values[2].red + values[3].red + values[4].red + values[5].red + values[6].red + values[7].red + values[8].red) / 9
      newValues = [[mean, mean, mean], [mean, mean, mean], [mean, mean, mean]]
      imageToWrite.setNeighborhood(neighborhood, newValues)
    imageToWrite

  segmentHorizontal: (image)->
    newImage = @cloneImage(image)
    paintPreviousRow = false
    inNonPaintArea = false
    for row in [0...image.rows]
      minIntensity = @white
      for column in [0...image.columns]
        intensity = image.getPixel(row, column).red
        minIntensity = intensity if intensity < minIntensity
      if minIntensity > 100
        if paintPreviousRow
          @paintRowColor(newImage, row - 1, @black) if !inNonPaintArea
          inNonPaintArea = false
        paintPreviousRow = true
      else
        inNonPaintArea = true
        paintPreviousRow = false
    newImage

  basicSegmentVertical: (image, newImage = null)->
    newImage = @cloneImage(image) if newImage == null
    paintPreviousColumn = false
    inNonPaintArea = false
    for column in [0...image.columns]
      minIntensity = @white
      for row in [0...image.rows]
        intensity = image.getPixel(row, column).red
        minIntensity = intensity if intensity < minIntensity
      if minIntensity > 100
        if paintPreviousColumn
          @paintColumnColor(newImage, column - 1, @black) if !inNonPaintArea
          inNonPaintArea = false
        paintPreviousColumn = true
      else
        inNonPaintArea = true
        paintPreviousColumn = false
    newImage

  basicSegmentVertical2: (imageData, newImage = null)->
    newImage = @cloneImage(imageData) if newImage == null
    for column in [0...imageData.columns]
      minIntensity = @white
      for row in [0...imageData.rows]
        intensity = imageData.getPixel(row, column).red
        minIntensity = intensity if intensity < minIntensity
      unless minIntensity < 100
        @paintColumnColor(newImage, column, @black)
    newImage

  paintRowColor: (image, row, color)->
    for column in [0...image.columns]
      pixel = image.getPixel(row, column)
      pixel.setAllValues(color)
      image.setPixel(pixel)


  getSegment: (originalImage, options)->
    columns = options.endColumn - options.startColumn
    rows = options.endRow - options.startRow
    imageData = @context.getImageData(
      options.startColumn,
      options.startRow,
      columns,
      rows)
    new App.Models.ImageData(imageData)

  findNextHorizontalSegment: (image, lastHorizontalSegment = 0)->
    row = lastHorizontalSegment || 0
    middle = image.columns / 2
    while image.getPixel(row, middle).red == @black
      row = row + 1
      return if row == image.rows
    top = row
    while image.getPixel(row, middle).red != @black
      row = row + 1
      return if row == image.rows
    bottom = row
    {
      startRow: top
      startColumn: 0
      endRow: bottom
      endColumn: image.columns
    }

  # Line Functions

  segmentVertical: (imageData, newImage = null)->
    newImage = @cloneImage(imageData) if newImage == null
    columns = []
    for column in [0...imageData.columns]
      minIntensity = @white
      for row in [0...imageData.rows]
        intensity = imageData.getPixel(row, column).red
        minIntensity = intensity if intensity < minIntensity
      unless minIntensity < @mid_gray
        columns.push(column)
    ranges = @getRangesOfWhitespace(columns)
    newImage = @paintRangesColor(newImage, @getEdges(ranges), @black)
    @paintRangesColor(newImage, @getSpaces(ranges), @mid_gray)

  paintRangesColor: (image, ranges, color)->
    for range in ranges
      for column in [range[0]..range[1]]
          @paintColumnColor(image, column, color)
    image

  paintColumnColor: (image, column, color)->
    for row in [0...image.rows]
      pixel = image.getPixel(row, column)
      pixel.setAllValues(color)
      image.setPixel(pixel)

  getRangesOfWhitespace: (columns)->
    start = null
    end = null
    ranges = []
    start = columns.shift()
    end = start
    while columns.length > 0
      next = columns.shift()
      if next == end + 1
        end = next
      else
        ranges.push([start, end, end - start])
        start = next
        end = next
    ranges.push([start, end, end - start])
    ranges

  getEdges: (ranges)->
    [ranges.shift(), ranges.pop()]


  getSpaces: (ranges)->
    _.reject ranges, (range)->
      range[2] < 7

  findNextVerticalSegment: (image, lastVerticalSegment = 0) ->
    column = lastVerticalSegment || 0
    while image.getPixel(0, column).red == @black || image.getPixel(0, column).red == 128
      column = column + 1
    left = column
    while image.getPixel(0, column).red != @black && image.getPixel(0, column).red != 128
      column = column + 1
    right = column
    {
      startRow: 0
      startColumn: left
      endRow: image.rows
      endColumn: right
    }
