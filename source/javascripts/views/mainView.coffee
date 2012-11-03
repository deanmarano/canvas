window.App.Views.MainView = Backbone.View.extend
  initialize: (options)->
    @canvas = options.canvas

  events:
    'mousemove #canvas': 'updatePickerColor'
    'click #invert': 'invert'
    'click #grayscale_average': 'grayscaleByAverage'
    'click #grayscale_luminosity': 'grayscaleByLuminosity'
    'click #restore': 'restore'
    'click #blur': 'blur'
    'click #segment': 'segment'

  updatePickerColor: (e)->
    pixel = @canvas.imageData.getPixel(e.pageY,e.pageX)
    @$('#picker').css('background-color', pixel.hex())
    @$('#picker').text(pixel.hex())
    @$('#picker').css('color', pixel.inverse().hex())

  invert: ->
    @canvas.inverse()

  blur: ->
    @canvas.blur()

  grayscaleByAverage: ->
    @canvas.grayscaleByAverage()

  grayscaleByLuminosity: ->
    @canvas.grayscaleByLuminosity()

  segment: ->
    @canvas.segmentImage()

  restore: ->
    @canvas.restore()
