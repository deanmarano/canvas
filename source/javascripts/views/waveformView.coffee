window.App.Templates.CharacterRow = $('#templates #characterSample tbody').html()
window.App.Views.WaveformView = Backbone.View.extend
  events:
    'click #showCharacters': 'showCharacters'
    'click #segmentCharacter': 'segment'
    'click #trimHorizontal': 'trimHorizontal'
    'click #trimVertical': 'trimVertical'
    'click #doItAll': 'doItAll'
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
    badChars = [91..96]
    badChars.push @i
    badChars.push @j
    badChars.push @l
    @rows = []
    for characterValue in [@A..@z]
      @rows.push @makeRow(table, characterValue) unless _.include badChars, characterValue

  showCharacters: ->
    _.each @rows, (textCanvas)->
      textCanvas.drawCharacter()

  segment: ->
    _.each @rows, (textCanvas)->
      textCanvas.segmentImage()

  trimHorizontal: ->
    _.each @rows, (textCanvas)->
      textCanvas.horizontalTrim()

  trimVertical: ->
    _.each @rows, (textCanvas)->
      textCanvas.verticalTrim()

  doItAll: ->
    _.each @rows, (textCanvas)->
      textCanvas.drawCharacter()
      textCanvas.segmentImage()
      textCanvas.horizontalTrim()
      textCanvas.verticalTrim()

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
      type: 'vertical'
    horizontalHist = new App.Views.HistogramView
      el: $row.find('.horizontalHistogram')
      canvas: textCanvas
      type: 'horizontal'
    textCanvas
