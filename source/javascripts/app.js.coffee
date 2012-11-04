#= require 'jquery'
#= require 'underscore'
#= require 'backbone'

#= require 'initializer'
#= require 'models/pixel'
#= require 'models/imageData'
#= require 'lib/imageFunctions'
#= require 'canvas'
#= require 'lineCanvas'
#= require 'views/mainView'
#= require 'views/histogramView'

$ ->
  window.canvas = new Canvas
  canvas.loadImage('images/scan1.jpg')
  new App.Views.MainView
    el: $('body')
    canvas: canvas
  new App.Views.HistogramView
    el: $('#histogram')
    canvas: canvas
