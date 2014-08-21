$ ->
  width = 400
  height = 200
  canvasContainer = $('#cvContainer')

  options = {
    numVisitors: 100,
    uncoop_rate: 0.2,
    speed: 0.2 / 10,
    numNeighbors: 1
  }

  stadium = new Stadium(width, height, options['numVisitors'])
  canvasContainer.append(stadium.canvas)

  $('#options form #numVisitors').val(options['numVisitors'])
  $('#options form #uncoop_rate').val(options['uncoop_rate'])
  $('#options form #speed').val(options['speed'])
  $('#options form #numNeighbors').val(options['numNeighbors'])

  $('#options form').submit((e) ->
    numVisitors = Number($('#options form #numVisitors').val())
    options['uncoop_rate'] = Number($('#options form #uncoop_rate').val())
    options['speed'] = Number($('#options form #speed').val())
    numNeighbors = Number($('#options form #numNeighbors').val())

    if numVisitors != options['numVisitors']
      options['numVisitors'] = numVisitors
      stadium.changeNumberOfVisitors(numVisitors, options)
    if numNeighbors != options['numNeighbors']
      options['numNeighbors'] = numNeighbors
      stadium.changeNumberOfNeighbors(numNeighbors, options)
    stadium.resetVisitors(options)
    e.preventDefault()
  )

  stadium.start()
