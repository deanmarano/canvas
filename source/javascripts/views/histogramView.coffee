window.App.Templates.HistogramBar = $('#templates #histogramBar').html()
window.App.Views.HistogramView = Backbone.View.extend
  initialize: (options)->
    @canvas = options.canvas
    @canvas.bind('updated', => @showHist())

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
    @$('ul').replaceWith($ul)

  showHist: ->
    result = _.countBy @canvas.imageData.getAllPixels(), (pixel)->
      pixel.average().red
    arrayResult = _.map [0..255], (index)->
      result[index] || 0
    @bars(arrayResult)
