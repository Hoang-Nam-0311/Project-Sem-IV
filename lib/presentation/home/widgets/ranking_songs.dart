// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:spotify_app/presentation/home/bloc/ranking_songs_cubit.dart';
// import 'package:spotify_app/presentation/home/bloc/ranking_songs_state.dart';
// import 'package:spotify_app/domain/entities/song/song.dart';

// class RankingPage extends StatelessWidget {
//   const RankingPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Bảng Xếp Hạng Bài Hát'),
//         backgroundColor: Colors.black,
//       ),
//       body: BlocProvider(
//         create: (context) => RankingSongsCubit()..getRankingSongs(),
//         child: BlocBuilder<RankingSongsCubit, RankingSongsState>(
//           builder: (context, state) {
//             if (state is RankingSongsLoading) {
//               return Center(child: CircularProgressIndicator());
//             } else if (state is RankingSongsLoaded) {
//               return Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: ListView.builder(
//                   itemCount: state.songs.length,
//                   itemBuilder: (context, index) {
//                     SongEntity song = state.songs[index];
//                     return _buildSongTile(song);
//                   },
//                 ),
//               );
//             } else if (state is RankingSongsLoadFailure) {
//               return Center(child: Text('Lỗi khi tải dữ liệu.'));
//             }
//             return Container(); // Trường hợp không xác định
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildSongTile(SongEntity song) {
//     return Card(
//       elevation: 4,
//       margin: const EdgeInsets.symmetric(vertical: 8.0),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: ListTile(
//         contentPadding: const EdgeInsets.all(16.0),
//         title: Text(
//           song.title,
//           style: const TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//         subtitle: Text(
//           'Số lần phát: ${song.playCount}',
//           style: TextStyle(color: Colors.grey[600]),
//         ),
//         trailing: IconButton(
//           icon: const Icon(Icons.favorite_border),
//           onPressed: () {
//             // Thêm logic để thêm bài hát vào danh sách yêu thích
//           },
//         ),
//       ),
//     );
//   }
// }
