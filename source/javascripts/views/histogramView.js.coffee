window.App.Templates.HistogramBar = $('#templates #histogramBar').html()
window.App.Views.HistogramView = Backbone.View.extend
  initialize: (options)->
    _.extend(@, Colors)
    @canvas = options.canvas
    @type = options.type
    @canvas.bind('updated', => @showHist())
    @canvas.bind('vertical:updated', => @verticalHist())
    @canvas.bind('horizontal:updated', => @horizontalHist())

  bars: (values)->
    max = _.max(values)
    height = @$el.height()
    width = @$el.width() / values.length
    $ul = $('<ul>')
    for value in values
      barHeight = (value / max) * height
      bar = _.template App.Templates.HistogramBar,
        width: width
        value: value
        barHeight: barHeight
        whitespaceHeight: height - barHeight
      $ul.append(bar)
    @$el.html($ul)

  showHist: ->
    result = _.countBy @canvas.image.getAllPixels(), (pixel)->
      pixel.average().red
    arrayResult = _.map [0..255], (index)->
      result[index] || 0
    @bars(arrayResult)

  verticalHist: ->
    return unless @type == 'vertical'
    imageData = @canvas.image
    values = []
    for column in [0...imageData.columns]
      columnValue = 0
      for row in [0...imageData.rows]
        intensity = imageData.getPixel(row, column).red
        columnValue = columnValue + 1 if intensity < @mid_gray
      values.push columnValue
    @bars(values)
    _.max values

  horizontalHist: ->
    return unless @type == 'horizontal'
    imageData = @canvas.image
    values = []
    for row in [0...imageData.rows]
      rowValue = 0
      for column in [0...imageData.columns]
        intensity = imageData.getPixel(row, column).red
        rowValue = rowValue + 1 if intensity < @mid_gray
      values.push rowValue
    @bars(values)
    _.max values

