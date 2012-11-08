class App.Lib.ImageFunctions
  constructor: (context)->
    @context = context

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

  blur: (imageToRead, imageToWrite)->
    imageToRead.eachPixel (pixel)=>
      neighborhood = imageToRead.get3x3Neighborhood(pixel.row, pixel.column)
      pixel.average()
      values = _.flatten(neighborhood)
      mean = _.reduce(values, (sum, pixel)->
        sum + pixel.red
      , 0) / values.length
      newValues = [[mean, mean, mean], [mean, mean, mean], [mean, mean, mean]]
      imageToWrite.setNeighborhood(neighborhood, newValues)
    imageToWrite

  segmentHorizontal: (imageData, newImage)->
    for row in [0...imageData.imageData.height]
      minIntensity = 255
      for column in [0...imageData.imageData.width]
        intensity = imageData.getPixel(row, column).red
        minIntensity = intensity if intensity < minIntensity
      unless minIntensity < 100
        for column in [0...imageData.imageData.width]
          pixel = imageData.getPixel(row, column)
          pixel.setAllValues(0)
          newImage.setPixel(pixel)
    newImage

  segmentVertical: (imageData, newImage)->
    columns = []
    for column in [0...imageData.imageData.width]
      minIntensity = 255
      for row in [0...imageData.imageData.height]
        intensity = imageData.getPixel(row, column).red
        minIntensity = intensity if intensity < minIntensity
      unless minIntensity < 125
        columns.push(column)
    ranges = @getRanges(columns)
    edges = @getEdges(ranges)
    spaces = @getSpaces(ranges)
    for range in edges
      for column in [range[0]..range[1]]
          for row in [0...imageData.imageData.height]
            pixel = imageData.getPixel(row, column)
            pixel.setAllValues(0)
            newImage.setPixel(pixel)

    for range in spaces
      for column in [range[0]..range[1]]
          for row in [0...imageData.imageData.height]
            pixel = imageData.getPixel(row, column)
            pixel.setAllValues(128)
            newImage.setPixel(pixel)

    newImage

  getRanges: (columns)->
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

  getSegment: (originalImage, rowOffset, columnOffset, endRow, endColumn)->
    width = endColumn - columnOffset
    height = endRow - rowOffset
    imageData = @context.createImageData(width, height)
    image = new App.Models.ImageData(imageData)
    for row in [0...height]
      for column in [0...width]
        pixel = originalImage.getPixel(rowOffset + row, columnOffset + column)
        pixel.start = undefined
        pixel.row = row
        pixel.column = column
        image.setPixel(pixel)
    image
