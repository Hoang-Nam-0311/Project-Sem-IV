import 'package:spotify_app/domain/entities/artist/artist.dart';

abstract class ArtistState {}

class ArtistLoading extends ArtistState {}

class ArtistLoaded extends ArtistState {
  final List<ArtistEntity> artists;

  ArtistLoaded({required this.artists});
}

class ArtistLoadFailure extends ArtistState {}
