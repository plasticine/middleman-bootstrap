beforeEach ->
  this.addMatchers
    toBePlaying: (expectedSong) ->
      player = this.actual
      player.currentlyPlayingSong is expectedSong and player.isPlaying
