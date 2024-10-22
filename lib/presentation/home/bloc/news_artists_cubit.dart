import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_app/domain/usecases/artist/get_news_artists.dart';
import 'package:spotify_app/presentation/home/bloc/news_artists_state.dart';
import 'package:spotify_app/service_locator.dart';

class ArtistCubit extends Cubit<ArtistState> {
  ArtistCubit() : super(ArtistLoading());

  Future<void> getArtists() async {
    var returnedArtists = await sl<GetArtistsUseCase>().call();
    returnedArtists.fold((failure) {
      emit(ArtistLoadFailure());
    }, (data) {
      emit(ArtistLoaded(artists: data));
    });
  }
}
