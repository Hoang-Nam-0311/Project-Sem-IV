import 'package:get_it/get_it.dart';
import 'package:spotify_app/data/repository/song/song_repository_impl.dart';
import 'package:spotify_app/data/sources/artist/artist_firebase_service.dart';
import 'package:spotify_app/data/sources/auth/auth_firebase_service.dart';
import 'package:spotify_app/data/sources/song/song_firebase_service.dart';
import 'package:spotify_app/domain/repository/auth/auth.dart';
import 'package:spotify_app/domain/repository/song/song.dart';
import 'package:spotify_app/domain/usecases/artist/get_news_artists.dart';
import 'package:spotify_app/domain/usecases/auth/get_user.dart';
import 'package:spotify_app/domain/usecases/auth/sigin.dart';
import 'package:spotify_app/domain/usecases/auth/signup.dart';
import 'package:spotify_app/domain/usecases/song/add_or_remove_favorite_song.dart';
import 'package:spotify_app/domain/usecases/song/get_favorite_songs.dart';
import 'package:spotify_app/domain/usecases/song/get_news_songs.dart';
import 'package:spotify_app/domain/usecases/song/get_play_list.dart';
import 'package:spotify_app/domain/usecases/song/is_favorite_song.dart';
import 'package:spotify_app/domain/repository/artist/artist.dart'; 
import 'package:spotify_app/data/repository/artist/artist_repository_impl.dart';


import 'data/repository/auth/auth_repository_impl.dart';


final sl = GetIt.instance;

Future<void> initializeDependencies() async {
 
 
 sl.registerSingleton<AuthFirebaseService>(
  AuthFirebaseServiceImpl()
 );

  sl.registerSingleton<AuthRepository>(
  AuthRepositoryImpl()
 );

 sl.registerSingleton<SongFirebaseService>(
  SongFirebaseServiceImpl()
 );
 

 sl.registerSingleton<SongsRepository>(
  SongRepositoryImpl()
 );

 sl.registerSingleton<SignupUseCase>(
  SignupUseCase()
 );

 sl.registerSingleton<SigninUseCase>(
  SigninUseCase()
 );

 sl.registerSingleton<GetNewsSongsUseCase>(
  GetNewsSongsUseCase()
 );

 sl.registerSingleton<GetPlayListUseCase>(
  GetPlayListUseCase()
 );

 sl.registerSingleton<AddOrRemoveFavoriteSongUseCase>(
  AddOrRemoveFavoriteSongUseCase()
 );

 sl.registerSingleton<IsFavoriteSongUseCase>(
  IsFavoriteSongUseCase()
 );

 sl.registerSingleton<GetUserUseCase>(
  GetUserUseCase()
 );

 sl.registerSingleton<GetFavoriteSongsUseCase>(
  GetFavoriteSongsUseCase()
 );
 
 sl.registerSingleton<ArtistsRepository>(
  ArtistRepositoryImpl()
);

sl.registerSingleton<GetArtistsUseCase>(
  GetArtistsUseCase()
);

sl.registerSingleton<ArtistFirebaseService>(
  ArtistFirebaseServiceImpl()
 );
}