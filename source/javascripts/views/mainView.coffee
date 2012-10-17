window.App.Views.MainView = Backbone.View.extend
  initialize: (options)->
    @canvas = options.canvas

  events:
    'mousemove #canvas': 'updatePickerColor'
    'click #invert': 'invert'
    'click #grayscale_average': 'grayscaleByAverage'
    'click #grayscale_luminosity': 'grayscaleByLuminosity'
    'click #restore': 'restore'

  updatePickerColor: (e)->
    pixel = @canvas.getPixel(e.clientY,e.clientX)
    @$('#picker').css('background-color', pixel.hex())
    @$('#picker').text(pixel.hex())
    @$('#picker').css('color', pixel.inverse().hex())

  invert: ->
    @canvas.inverse()

  grayscaleByAverage: ->
    @canvas.grayscaleByAverage()

  grayscaleByLuminosity: ->
    @canvas.grayscaleByLuminosity()

  restore: ->
    @canvas.restore()
