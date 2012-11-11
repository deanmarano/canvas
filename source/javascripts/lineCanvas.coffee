class window.LineCanvas
  constructor: ->
    @canvas = document.getElementById("lineCanvas")
    @context = @canvas.getContext('2d')
    @imgFunctions = new App.Lib.ImageFunctions(@context)

  showImage: (image)->
    @lastFoundSegment = 0
    @image = image
    @writeImage(@image)

  writeImage: (image)->
    @canvas.width = image.columns
    @canvas.height = image.rows
    @context.putImageData(image.imageData, 0, 0)

  segmentVertical: ->
    @image = @imgFunctions.basicSegmentVertical(@image)
    @writeImage(@image)

  findNextCharacter: ->
    nextSegment = @imgFunctions.findNextVerticalSegment(@image, @lastFoundSegment)
    return unless nextSegment
    @lastFoundSegment = nextSegment.endColumn
    @imgFunctions.getSegment(@image, nextSegment)
