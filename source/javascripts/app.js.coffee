#= require 'jquery'
#= require 'underscore'
#= require 'backbone'

#= require 'initializer'
#= require 'models/pixel'
#= require 'canvas'
#= require 'views/mainView'
#= require 'views/histogramView'

$ ->
  window.canvas = new Canvas
  #canvas.loadImage('images/flower.jpeg')
  canvas.loadImage('images/kitten.png')
  new App.Views.MainView
    el: $('body')
    canvas: canvas
  new App.Views.HistogramView
    el: $('#histogram')
    canvas: canvas
