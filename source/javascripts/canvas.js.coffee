class window.Canvas
  constructor: ->
    _.extend(@, Backbone.Events)
    _.extend(@, Colors)
    @canvas = document.getElementById("canvas")
    @context = @canvas.getContext('2d')
    @imgFunctions = new App.Lib.ImageFunctions(@context)

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

  loadImageDataFromCanvas: (columns, rows)->
    imageData = @context.getImageData(0, 0, columns, rows)
    new App.Models.ImageData(imageData)

  grayscaleByLuminosity: ->
    @callAndWrite(@imgFunctions.grayscaleByLuminosity)

  grayscaleByAverage: ->
    @callAndWrite(@imgFunctions.grayscaleByAverage)

  inverse: ->
    @callAndWrite(@imgFunctions.inverse)

  blur: ->
    @callAndWrite(@imgFunctions.blur)

  segmentImage: ->
    image = @imgFunctions.grayscaleByAverage(@image)
    image = @imgFunctions.segmentHorizontal(image)

    @image = image
    @writeImage(@image)
    @lastFoundSegment = 0
    while @findNextLine()
      true
    @lastFoundSegment = 0
    @image = @loadImageDataFromCanvas(@image.columns, @image.rows)


  segmentHorizontally: ->
    @callAndWrite(@imgFunctions.segmentHorizontal)

  callAndWrite: (func) ->
    @image = func.call(@imgFunctions, @image)
    @writeImage(@image)

  segment: (bottom, top, newColor)->
    @image.eachPixel (pixel)=>
      if bottom < pixel.average().red < top
        pixel.setAllValues(newColor)
        @image.setPixel(pixel)
    @writeImage(@image)

  restore: ->
    @showImage(@imgFunctions.cloneImage(@originalImage))

  showImage: (image)->
    @lastFoundSegment = 0
    @image = image
    @writeImage(@image)

  writeImage: (image)->
    @trigger('updated')
    @canvas.width = image.columns
    @canvas.height = image.rows
    @context.putImageData(image.imageData, 0, 0)

  findNextLine: ->
    nextSegment = @imgFunctions.findNextHorizontalSegment(@image, @lastFoundSegment)
    return unless nextSegment
    @lastFoundSegment = nextSegment.endRow
    segment = @imgFunctions.getSegment(@image, nextSegment)
    image = @imgFunctions.segmentVertical(segment)
    @context.putImageData(image.imageData, 0, nextSegment.startRow)
    segment
