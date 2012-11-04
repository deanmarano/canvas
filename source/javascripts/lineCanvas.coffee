class window.LineCanvas
  constructor: ->
    @canvas = document.getElementById("secondCanvas")
    @context = @canvas.getContext('2d')
    @imgFunctions = new App.Lib.ImageFunctions

  showImage: (image)->
    @canvas.width = image.width()
    @canvas.height = image.height()
    @context.putImageData(image.imageData, 0, 0)
