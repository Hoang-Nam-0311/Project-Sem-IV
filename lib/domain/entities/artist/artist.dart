import 'package:cloud_firestore/cloud_firestore.dart';
class ArtistEntity {
  final String name;
final Timestamp releaseDate;
  ArtistEntity({
    required this.name,
    required this.releaseDate,
  });
}
