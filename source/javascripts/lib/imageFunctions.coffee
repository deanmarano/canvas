class App.Lib.ImageFunctions
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
    for column in [0...imageData.imageData.width]
      minIntensity = 255
      for row in [0...imageData.imageData.height]
        intensity = imageData.getPixel(row, column).red
        minIntensity = intensity if intensity < minIntensity
      unless minIntensity < 100
        for row in [0...imageData.imageData.height]
          pixel = imageData.getPixel(row, column)
          pixel.setAllValues(0)
          newImage.setPixel(pixel)
    newImage
