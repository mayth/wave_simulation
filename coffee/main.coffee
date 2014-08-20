$ ->
  width = 400
  height = 200
  numVisitor = 100
  canvasContainer = $('#cvContainer')

  stadium = new Stadium(width, height, numVisitor)
  canvasContainer.append(stadium.canvas)

  stadium.start()
