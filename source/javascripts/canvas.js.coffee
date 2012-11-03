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
    new App.Models.ImageData(imageData)

  loadImageDataFromCanvas: (width, height)->
    @context.getImageData(0, 0, width, height)

  gaussian: ->
    originalImage = @cloneImage(@imageData)
    for row in [0...@imageData.height]
      for column in [0...@imageData.width]
        neighborhood = @get3x3Neighborhood(row, column)
        values = _.flatten(neighborhood)
        mean = _.reduce(values, (sum, pixel)->
          sum + pixel.red
        , 0) / values.length
        pixelOfInterest = neighborhood[1][1]
        pixelOfInterest.inverse()
        #pixelOfInterest.gaussian(mean)
        @setPixel(pixelOfInterest)
    @writeImage(@imageData)

  blur: ->
    newImage = @cloneImage(@imageData.imageData)
    @imageData.eachPixel (pixel)=>
      neighborhood = @imageData.get3x3Neighborhood(pixel.row, pixel.column)
      pixel.average()
      values = _.flatten(neighborhood)
      mean = _.reduce(values, (sum, pixel)->
        sum + pixel.red
      , 0) / values.length
      newValues = [[mean, mean, mean], [mean, mean, mean], [mean, mean, mean]]
      newImage.setNeighborhood(neighborhood, newValues)
    @writeImage(newImage)

  grayscaleByAverage: (image)->
    image.eachPixel (pixel)->
      pixel.average()
    image

  grayscaleByLuminosity: ->
    @imageData.eachPixel (pixel)->
      pixel.averageLuminosity()
    @writeImage(@imageData)

  inverse: ->
    @imageData.eachPixel (pixel)->
      pixel.inverse()
    @writeImage(@imageData)

  segmentImage: ()->
    imageToRead = @grayscaleByAverage(@imageData)
    imageToWrite = @cloneImage(@imageData.imageData)

    horizontallySegmentedImage = @segmentLines(imageToRead, imageToWrite)
    finalImage = @segmentVertical(imageToRead, horizontallySegmentedImage)
    @writeImage(finalImage)

  segmentLines: (imageData, newImage)->
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
