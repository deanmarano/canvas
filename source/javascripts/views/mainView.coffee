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
    'click #colorSegment': 'colorSegmentation'
    'click #segment': 'segment'
    'click #showNextSegment': 'showNextSegment'
    'change .imageSelect' : 'changeImage'

  changeImage: (e)->
    canvas.loadImage(e.currentTarget.value)

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

  colorSegmentation: ->
    @canvas.segment(200, 255, 255)

  showNextSegment: ->
    canvas2 = new window.LineCanvas
    result = @canvas.findSegment()
    canvas2.showImage(canvas.getSegment(result[0], result[1], result[2], result[3]))

  restore: ->
    @canvas.restore()
