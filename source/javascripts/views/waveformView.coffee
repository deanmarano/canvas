window.App.Templates.CharacterRow = $('#templates #characterSample tbody').html()
window.App.Views.WaveformView = Backbone.View.extend
  render: ->
    table = @$('tbody')
    @A = 65
    @Z = 90
    @a = 97
    @i = 105
    @j = 106
    @k = 107
    @l = 108
    @m = 109
    @z = 122
    #for characterValue in [@A..@A]
      #makeRow(table, characterValue)
    for characterValue in [@A..@Z]
      @makeRow(table, characterValue)
    for characterValue in [@a...@i]
      @makeRow(table, characterValue)
    for characterValue in [@m..@z]
      @makeRow(table, characterValue)


  makeRow: (table, characterValue)->
    character = String.fromCharCode(characterValue)
    row = _.template App.Templates.CharacterRow,
      value: characterValue
      character: character
    table.append(row)
    $row = table.children().last()
    canvas = $row.find('canvas')[0]
    textCanvas = new TextCanvas
      character: character
      canvas: canvas
    vertHist = new App.Views.HistogramView
      el: $row.find('.verticalHistogram')
      canvas: textCanvas
    vertHist.verticalHist()
    horizontalHist = new App.Views.HistogramView
      el: $row.find('.horizontalHistogram')
      canvas: textCanvas
    horizontalHist.horizontalHist()
