class window.Visitor
  EPS = 0.00000001

  constructor: (@x, options = {}) ->
    @neighbors = new Array
    @reset(options)

  reset: (options = {}) =>
    @standing = 0.0
    @isReservingStartingWave = false
    @vStanding = 0.0
    @uncoop_rate = options['uncoop_rate'] ? 0.2
    @speed = options['speed'] ? (0.2 / 10)

  update: (now) =>
    if @isReservingStartingWave
      @isReservingStartingWave = false
      @vStanding = +@speed
    @standing += @vStanding
    if @isMoving()
      if @isFinishStanding()
        @standing = 1.0
        @vStanding = -@vStanding
      else if @isFinishWaving()
        @vStanding = 0.0
        @standing = 0.0
    for n in (v for v in @neighbors when v.isStandingUp())
      @wave() unless @isUncooperative()

  isMoving: () => Math.abs(@vStanding) > EPS

  isFinishStanding: () => Math.abs(@standing + @vStanding - 1.0) < EPS

  isStandingUp: () => @isMoving() and @vStanding > 0

  isSittingDown: () => @isMoving() and @vStanding < 0

  isFinishWaving: () => @standing < EPS

  isNeighborMoving: () => @neighbors.some (e) -> e.isMoving()

  isUncooperative: () => Math.random() < @uncoop_rate

  wave: () =>
    @isReservingStartingWave = true unless @isMoving()
