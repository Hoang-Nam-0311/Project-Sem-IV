import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_app/core/configs/constants/app_urls.dart';
import 'package:spotify_app/domain/entities/artist/artist.dart';
import 'package:spotify_app/presentation/home/bloc/news_artists_cubit.dart';
import 'package:spotify_app/presentation/home/bloc/news_artists_state.dart';


class ArtistsTab extends StatelessWidget {
  const ArtistsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ArtistCubit()..getArtists(),
      child: SizedBox(
        height: 200,
        child: BlocBuilder<ArtistCubit, ArtistState>(
          builder: (context, state) {
            if (state is ArtistLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is ArtistLoaded) {
              return _artistsList(state.artists);
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _artistsList(List<ArtistEntity> artists) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return SizedBox(
          width: 150,
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center, 
          crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                 Container(
                  width: 170, 
                  height: 170,
                  decoration: BoxDecoration(
                     shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          '${AppURLs.artistFirestorage}${artists[index].name}.jpg?${AppURLs.mediaAlt}'),
                    ),
                  ),
                ),
              Text(
                artists[index].name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(width: 15),
      itemCount: artists.length,
    );
  }
}
