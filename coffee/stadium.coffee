class window.Stadium
  @requestAnimationFrame: (callback) ->
    (window.requestAnimationFrame or
      window.mozRequestAnimationFrame or
      window.webkitRequestAnimationFrame or
      window.msRequestAnimationFrame or
      (f) -> window.setTimeout(f, 1000 / @fps)
    )(callback)

  MARGIN = 10

  ticks: 0

  constructor: (width, height, @numVisitors, @numNeighbors = 1, visitorOptions = {}) ->
    @width = width - MARGIN * 2
    @height = height - MARGIN * 2
    @fullResetVisitors(visitorOptions)
    @generateCanvas(width, height)

  generateCanvas: (width, height) ->
    @canvas = document.createElement('canvas')
    @canvas.width = width
    @canvas.height = height
    unsupportedText = document.createTextNode('Your browser doesn\'t support Canvas. Please upgrade the browser or use the other one.')
    @canvas.appendChild(unsupportedText)
    @canvas.addEventListener('click', @startWave)

  start: =>
    Stadium.requestAnimationFrame(@update)

  update: (now) =>
    @draw(now)
    for v in @visitors
      v.update(@ticks)
    ++@ticks
    Stadium.requestAnimationFrame(@update)

  draw: (now) =>
    ctx = @canvas.getContext('2d')
    ctx.beginPath()
    ctx.clearRect(0, 0, @canvas.width, @canvas.height)
    for v in @visitors
      @drawPoint(MARGIN + v.x, @height + MARGIN - v.standing * @height, 1)

  startWave: () =>
    tgt = Math.floor(Math.random() * (@numVisitors - 1))
    @visitors[tgt].wave()
    console.log "start waving from #{tgt}"
    tgt

  changeNumberOfVisitors: (n, visitorOptions = {}) =>
    @numVisitors = n
    @fullResetVisitors(visitorOptions)

  changeNumberOfNeighbors: (n, visitorOptions = {}) =>
    @numNeighbors = n
    @fullResetVisitors(visitorOptions)

  fullResetVisitors: (options = {}) =>
    dx = @width / @numVisitors
    @visitors = new Array(@numVisitors)
    for i in [0...@numVisitors]
      @visitors[i] = new Visitor(i * dx, options)
    for v, i in @visitors
      for j in [1..@numNeighbors]
        k =
          if i - j < 0
            @numVisitors - j
          else
            i - j
        v.neighbors.push(@visitors[k])
      for j in [1..@numNeighbors]
        v.neighbors.push(@visitors[(i + j) % @numVisitors])

  resetVisitors: (options = {}) =>
    for v in @visitors
      v.reset(options)

  drawPoint: (x, y, r, color = {}) =>
    cr = color['r'] || 0
    cg = color['g'] || 0
    cb = color['b'] || 0
    ca = color['a'] || 1.0
    ctx = @canvas.getContext('2d')
    ctx.beginPath()
    ctx.fillStyle = "rgba(#{cr},#{cg},#{cb},#{ca});"
    ctx.arc(x, y, r, 0, Math.PI * 2, false)
    ctx.fill()
