#= require 'jquery'
#= require 'underscore'
#= require 'backbone'

#= require 'initializer'
#= require 'models/pixel'
#= require 'canvas'
#= require 'views/mainView'

$ ->
  window.canvas = new Canvas
  canvas.loadImage()
  new App.Views.MainView
    el: $('body')
    canvas: canvas
