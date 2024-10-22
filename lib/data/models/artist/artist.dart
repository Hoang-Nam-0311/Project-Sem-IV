import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotify_app/domain/entities/artist/artist.dart';

class ArtistModel {
  String? name;
  Timestamp? releaseDate;

  ArtistModel({
    required this.name,
    required this.releaseDate,

  });

  ArtistModel.fromJson(Map<String, dynamic> data) {
    name = data['name'];
    releaseDate = data['releaseDate'];
  }
}

extension ArtistModelX on ArtistModel {
  ArtistEntity toEntity() {
    return ArtistEntity(
      name: name!,
       releaseDate: releaseDate!,
    );
  }
}
