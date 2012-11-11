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
#= require 'canvases/textCanvas'
#= require 'views/mainView'
#= require 'views/histogramView'
#= require 'views/waveformView'


$ ->
  window.canvas = new Canvas
  canvas.loadImage('images/scan1.jpg')
  window.lineCanvas = new LineCanvas
  window.characterCanvas = new CharacterCanvas
    el: $('#characterCanvas')
  waveformView = new App.Views.WaveformView
    el: $('#characterTable')
  new App.Views.MainView
    el: $('body')
    canvas: canvas
    lineCanvas: lineCanvas
    characterCanvas: characterCanvas
    waveformView: waveformView
  new App.Views.HistogramView
    el: $('#histogram')
    canvas: canvas


  new App.Views.HistogramView
    el: $('#histogram')
    canvas: canvas
