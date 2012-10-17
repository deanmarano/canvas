class App.Models.Pixel
  constructor: (red, green, blue, alpha, start)->
    @red = red
    @green = green
    @blue = blue
    @alpha = alpha
    @start = start

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

  gaussian: (mean, standardDeviation = .01)->
    intensity = @red / 255
    mean = mean / 255
    multiplier = (1 / (Math.sqrt(2 * Math.PI) * standardDeviation))
    exponentTop = Math.pow(intensity - mean, 2)
    exponentBottom = 2 * Math.pow(standardDeviation, 2)
    part = Math.pow(Math.E, -(exponentTop/exponentBottom))
    result = multiplier * part
    console.log(result)
    @setAllValues(result)

  averageLuminosity: ->
    average = 0.21*@red + 0.71*@green + 0.07*@blue
    @red = average
    @green = average
    @blue = average
    @
