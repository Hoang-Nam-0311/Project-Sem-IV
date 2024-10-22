import 'package:dartz/dartz.dart';
import 'package:spotify_app/data/sources/artist/artist_firebase_service.dart';
import 'package:spotify_app/domain/entities/artist/artist.dart';
import 'package:spotify_app/domain/repository/artist/artist.dart';
import 'package:spotify_app/service_locator.dart';

class ArtistRepositoryImpl extends ArtistsRepository {
  @override
  Future<Either<String, List<ArtistEntity>>> getNewsArtists() async {
    return await sl<ArtistFirebaseService>().getNewsArtists();
  }
}
