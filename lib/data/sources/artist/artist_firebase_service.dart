import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:spotify_app/data/models/artist/artist.dart';
import 'package:spotify_app/domain/entities/artist/artist.dart';

abstract class ArtistFirebaseService {
  Future<Either<String, List<ArtistEntity>>> getNewsArtists();
}

class ArtistFirebaseServiceImpl extends ArtistFirebaseService {
  @override
  Future<Either<String, List<ArtistEntity>>> getNewsArtists() async {
    try {
      List<ArtistEntity> artists = [];
      var data = await FirebaseFirestore.instance
          .collection('Artits')
          .orderBy('releaseDate', descending: true)
          .limit(5)
          .get();

      for (var element in data.docs) {
        var artistModel = ArtistModel.fromJson(element.data());
        artists.add(artistModel.toEntity());
      }

      return Right(artists);
    } catch (e) {
      return const Left('An error occurred, Please try again.');
    }
  }
}
