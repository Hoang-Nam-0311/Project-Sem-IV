import 'package:dartz/dartz.dart';
import 'package:spotify_app/core/usecase/usecase.dart';

import '../../../service_locator.dart';
import '../../repository/artist/artist.dart'; // Repository cho Artist

class GetArtistsUseCase implements UseCase<Either, dynamic> {
  @override
  Future<Either> call({params}) async {
    return await sl<ArtistsRepository>().getNewsArtists();
  }
}
