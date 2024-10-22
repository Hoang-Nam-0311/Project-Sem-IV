abstract class SongPlayerState {}




class SongPlayerLoading extends SongPlayerState {}

class SongPlayerLoaded extends SongPlayerState {
  final Duration duration;
  final Duration position;
  final bool isPlaying;
  final String currentSongUrl;

  SongPlayerLoaded({
    required this.duration,
    required this.position,
    required this.isPlaying,
    required this.currentSongUrl,
  });
}

class SongPlayerFailure extends SongPlayerState {
  final String message;

  SongPlayerFailure({required this.message});
}
class SongPlayerInitialized extends SongPlayerState {}
