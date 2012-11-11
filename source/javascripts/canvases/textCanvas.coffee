class window.TextCanvas
  constructor: (options)->
    _.extend(@, Backbone.Events)
    @canvas = options.canvas
    @context = @canvas.getContext('2d')
    @imgFunctions = new App.Lib.ImageFunctions(@context)
    @context.fillStyle = 'white'
    @context.fillRect(0,0,150, 150)
    @context.font = "bold 48px serif"
    @context.fillStyle = '#111'
    @context.textBaseline = 'top'
    @context.fillText(options.character, 60, 60)
    @image = @loadImageDataFromCanvas(150, 150)
    @segment()

  showImage: (image)->
    @image = image
    @writeImage()

  loadImageDataFromCanvas: (columns, rows)->
    imageData = @context.getImageData(0, 0, columns, rows)
    new App.Models.ImageData(imageData)

  writeImage: ->
    @canvas.width = @image.columns
    @canvas.height = @image.rows
    @context.putImageData(@image.imageData, 0, 0)

  segment: ->
    #@image = @imgFunctions.segmentHorizontal2(@image)
    #@writeImage()

    newImage = @imgFunctions.segmentHorizontal(@image)
    @image = @imgFunctions.basicSegmentVertical(@image, newImage)
    @writeImage()
    nextSegment = @imgFunctions.findNextHorizontalSegment(@image)
    @image = @imgFunctions.getSegment(@image, nextSegment)
    @writeImage()
    @image = @imgFunctions.basicSegmentVertical(@image)
    @writeImage()
    nextSegment = @imgFunctions.findNextVerticalSegment(@image)
    @image = @imgFunctions.getSegment(@image, nextSegment)
    @writeImage()
