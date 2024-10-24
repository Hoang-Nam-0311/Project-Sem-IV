import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:spotify_app/common/helpers/is_dark_mode.dart';
import 'package:spotify_app/common/widgets/appbar/app_bar.dart';
import 'package:spotify_app/presentation/profile/bloc/favorite_songs_cubit.dart';
import 'package:spotify_app/presentation/profile/bloc/favorite_songs_state.dart';
import 'package:spotify_app/presentation/profile/bloc/profile_info_cubit.dart';
import 'package:spotify_app/presentation/song_player/pages/song_player.dart';
import 'package:spotify_app/presentation/auth/pages/signin.dart';

import '../../../common/widgets/favorite_button/favorite_button.dart';
import '../../../core/configs/constants/app_urls.dart';
import '../bloc/profile_info_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        backgroundColor: const Color(0xff2C2B2B),
        title: const Text('Profile'),
        action: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            await _logout(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _profileInfo(context),
          const SizedBox(height: 30),
          _favoriteSongs(),
        ],
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut(); // Perform the logout
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => SigninPage()), // Navigate to sign-in page
      (Route<dynamic> route) => false,
    );
  }

  Widget _profileInfo(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileInfoCubit()..getUser(),
      child: Container(
        height: MediaQuery.of(context).size.height / 3.5,
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.isDarkMode ? const Color(0xff2C2B2B) : Colors.white,
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(50),
            bottomLeft: Radius.circular(50),
          ),
        ),
        child: BlocBuilder<ProfileInfoCubit, ProfileInfoState>(
          builder: (context, state) {
            if (state is ProfileInfoLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileInfoLoaded) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundImage:
                        NetworkImage(state.userEntity.imageURL ?? ''),
                  ),
                  const SizedBox(height: 15),
                  Text(state.userEntity.email ?? ''),
                  const SizedBox(height: 10),
                  Text(
                    state.userEntity.fullName ?? '',
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              );
            } else if (state is ProfileInfoFailure) {
              return const Center(child: Text('Please try again.'));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _favoriteSongs() {
    return BlocProvider(
      create: (context) => FavoriteSongsCubit()..getFavoriteSongs(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Favorite songs',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 20),
            BlocBuilder<FavoriteSongsCubit, FavoriteSongsState>(
              builder: (context, state) {
                if (state is FavoriteSongsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is FavoriteSongsLoaded) {
                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: state.favoriteSongs.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 20),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SongPlayerPage(
                                  songEntity: state.favoriteSongs[index]),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        '${AppURLs.coverFirestorage}${state.favoriteSongs[index].title}-${state.favoriteSongs[index].artist}.jpg?${AppURLs.mediaAlt}',
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.favoriteSongs[index].title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      state.favoriteSongs[index].artist,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(state.favoriteSongs[index].duration
                                    .toString()
                                    .replaceAll('.', ':')),
                                const SizedBox(width: 20),
                                FavoriteButton(
                                  songEntity: state.favoriteSongs[index],
                                  key: UniqueKey(),
                                  function: () {
                                    context
                                        .read<FavoriteSongsCubit>()
                                        .removeSong(index);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else if (state is FavoriteSongsFailure) {
                  return const Center(child: Text('Please try again.'));
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
