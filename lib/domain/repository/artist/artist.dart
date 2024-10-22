import 'package:dartz/dartz.dart';

abstract class ArtistsRepository {
  Future<Either> getNewsArtists();
}
