class window.Visitor
  EPS = 0.00000001
  VELOCITY = 0.2 / 10

  constructor: (@x) ->
    @neighbors = new Array
    @standing = 0.0
    @isReservingStartingWave = false
    @waveStartsAt = null
    @vStanding = 0.0

  update: (now) =>
    if @isReservingStartingWave
      @isReservingStartingWave = false
      waveStartsAt = now
      @vStanding = +VELOCITY
    @standing += @vStanding
    if Math.abs(@vStanding) > EPS
      if Math.abs(@standing + @vStanding - 1.0) < EPS
        @standing = 1.0
        @vStanding = -@vStanding
      else if @standing < EPS
        @vStanding = 0.0
        @standing = 0.0

  wave: () =>
    @isReservingStartingWave = true
