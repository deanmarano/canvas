#= require 'jquery'
#= require 'underscore'
#= require 'backbone'

#= require 'initializer'
#= require 'colors'
#= require 'models/pixel'
#= require 'models/imageData'
#= require 'lib/imageFunctions'
#= require 'canvas'
#= require 'lineCanvas'
#= require 'canvases/characterCanvas'
#= require 'views/mainView'
#= require 'views/histogramView'

$ ->
  window.canvas = new Canvas
  canvas.loadImage('images/scan1.jpg')
  window.lineCanvas = new LineCanvas
  window.characterCanvas = new CharacterCanvas
  new App.Views.MainView
    el: $('body')
    canvas: canvas
    lineCanvas: lineCanvas
    characterCanvas: characterCanvas
  new App.Views.HistogramView
    el: $('#histogram')
    canvas: canvas
