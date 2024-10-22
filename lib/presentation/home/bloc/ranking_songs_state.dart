import 'package:spotify_app/domain/entities/song/song.dart';

abstract class RankingSongsState {}

class RankingSongsLoading extends RankingSongsState {}

class RankingSongsLoaded extends RankingSongsState {
  final List<SongEntity> songs;
  RankingSongsLoaded({required this.songs});
}

class RankingSongsLoadFailure extends RankingSongsState {}
