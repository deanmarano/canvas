App.Views.HistogramView = Backbone.View.extend
  initialize:
    @model.bind('change:test', 'test')
  test: ->
    console.log('testing')

