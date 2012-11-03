window.App.Views.MainView = Backbone.View.extend
  initialize: (options)->
    @canvas = options.canvas

  events:
    'mousemove #canvas': 'updatePickerColor'
    'click #invert': 'invert'
    'click #grayscale_average': 'grayscaleByAverage'
    'click #grayscale_luminosity': 'grayscaleByLuminosity'
    'click #gaussian': 'gaussian'
    'click #restore': 'restore'
    'click #blur': 'blur'

  updatePickerColor: (e)->
    pixel = @canvas.imageData.getPixel(e.pageY,e.pageX)
    @$('#picker').css('background-color', pixel.hex())
    @$('#picker').text(pixel.hex())
    @$('#picker').css('color', pixel.inverse().hex())

  invert: ->
    @canvas.inverse()

  gaussian: ->
    @canvas.gaussian()

  blur: ->
    @canvas.blur()

  grayscaleByAverage: ->
    image = @canvas.grayscaleByAverage(@canvas.imageData)
    @canvas.writeImage(image)

  grayscaleByLuminosity: ->
    @canvas.grayscaleByLuminosity()

  restore: ->
    @canvas.restore()
