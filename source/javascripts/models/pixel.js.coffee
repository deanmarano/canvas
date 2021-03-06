class App.Models.Pixel
  constructor: (red, green, blue, alpha, start, row, column)->
    @red = red
    @green = green
    @blue = blue
    @alpha = alpha
    @start = start
    @row = row
    @column = column

  hex: ->
    red = @valueToHex(@red)
    blue = @valueToHex(@blue)
    green = @valueToHex(@green)
    "##{red}#{green}#{blue}"

  valueToHex: (value)->
    value = value.toString(16)
    if value.length == 1 then value = "0#{value}" else value

  inverse: ->
    @red = 255 - @red
    @green = 255 - @green
    @blue = 255 - @blue
    @

  average: ->
    average = Math.floor((@red + @green + @blue) / 3)
    @setAllValues(average)
    @

  setAllValues: (value)->
    @red = value
    @green = value
    @blue = value

  averageLuminosity: ->
    average = 0.21*@red + 0.71*@green + 0.07*@blue
    @red = average
    @green = average
    @blue = average
    @
