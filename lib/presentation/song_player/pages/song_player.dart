import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_app/common/widgets/appbar/app_bar.dart';
import 'package:spotify_app/common/widgets/favorite_button/favorite_button.dart';
import 'package:spotify_app/domain/entities/song/song.dart';
import 'package:spotify_app/presentation/song_player/bloc/song_player_cubit.dart';
import 'package:spotify_app/presentation/song_player/bloc/song_player_state.dart';
import 'package:http/http.dart' as http; // Import package http
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import '../../../core/configs/constants/app_urls.dart';
// import '../../../core/configs/theme/app_colors.dart';
// ignore: unused_import
import 'package:id3_codec/id3_codec.dart';

class SongPlayerPage extends StatelessWidget {
  final SongEntity songEntity;
  const SongPlayerPage({required this.songEntity, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        title: const Text(
          'Audio',
          style: TextStyle(fontSize: 18),
        ),
        action: IconButton(
            onPressed: () {}, icon: const Icon(Icons.more_vert_rounded)),
      ),
      body: BlocProvider(
        create: (_) => SongPlayerCubit()
          ..loadSong(
              '${AppURLs.songFirestorage}${songEntity.title}-${songEntity.artist}.mp3?${AppURLs.mediaAlt}'),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Builder(builder: (context) {
            return Column(
              children: [
                _songCover(context),
                const SizedBox(
                  height: 20,
                ),
                _songDetail(),
                const SizedBox(
                  height: 30,
                ),
                _songPlayer(context)
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _songCover(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                  '${AppURLs.coverFirestorage}${songEntity.title}-${songEntity.artist}.jpg?${AppURLs.mediaAlt}'))),
    );
  }

  Widget _songDetail() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              songEntity.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              songEntity.artist,
              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
            ),
          ],
        ),
        FavoriteButton(songEntity: songEntity)
      ],
    );
  }

  Widget _songPlayer(BuildContext context) {
    return BlocBuilder<SongPlayerCubit, SongPlayerState>(
      builder: (context, state) {
        if (state is SongPlayerLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is SongPlayerLoaded) {
          return Column(
            children: [
              Slider(
                value: context
                    .read<SongPlayerCubit>()
                    .songPosition
                    .inSeconds
                    .toDouble(),
                min: 0.0,
                max: context
                    .read<SongPlayerCubit>()
                    .songDuration
                    .inSeconds
                    .toDouble(),
                onChanged: (value) {
                  context
                      .read<SongPlayerCubit>()
                      .audioPlayer
                      .seek(Duration(seconds: value.toInt()));
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formatDuration(
                      context.read<SongPlayerCubit>().songPosition)),
                  Text(formatDuration(
                      context.read<SongPlayerCubit>().songDuration))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shuffle,
                        size: 30, color: Color.fromARGB(255, 255, 255, 255)),
                    onPressed: () {
                      // Logic for shuffle
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_previous,
                        size: 30, color: Color.fromARGB(255, 255, 255, 255)),
                    onPressed: () {
                      context.read<SongPlayerCubit>().previousSong();
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      context.read<SongPlayerCubit>().playOrPauseSong();
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                      child: Icon(
                        context.read<SongPlayerCubit>().audioPlayer.playing
                            ? Icons.pause
                            : Icons.play_arrow,
                        size: 30,
                        color: const Color.fromARGB(255, 15, 15, 15),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_next,
                        size: 30, color: Color.fromARGB(255, 255, 255, 255)),
                    onPressed: () {
                      context.read<SongPlayerCubit>().nextSong();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.timer,
                        size: 30, color: Color.fromARGB(255, 255, 255, 255)),
                    onPressed: () {
                      // Logic for liking the song
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.share,
                        size: 30, color: Color.fromARGB(255, 255, 255, 255)),
                    onPressed: () {
                      // Logic for sharing the song
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.bluetooth_connected,
                        size: 30, color: Color.fromARGB(255, 255, 255, 255)),
                    onPressed: () {
                      // Logic for connecting device
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              FutureBuilder<String>(
                future: extractLyricsFromMp3(
                    '${AppURLs.songFirestorage}${Uri.encodeComponent(songEntity.title)}-${Uri.encodeComponent(songEntity.artist)}.mp3?${AppURLs.mediaAlt}'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Không thể tải lời bài hát: ${snapshot.error}');
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Lời bài hát:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            snapshot.data!, // Hiển thị lời bài hát
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Text('Không có lời bài hát.');
                  }
                },
              ),
            ],
          );
        }

        return Container();
      },
    );
  }

  // Phương thức trích xuất lời bài hát từ file MP3
 Future<String> extractLyricsFromMp3(String songUrl) async {
  try {
    // Tải file MP3 từ Firebase
    final response = await http.get(Uri.parse('$songUrl?alt=media'));
    print('Song URL: $songUrl');
    if (response.statusCode != 200) {
      print('Không thể tải tệp MP3, mã lỗi: ${response.statusCode}');
      return 'Không thể tải tệp MP3.';
    }

    // Lưu file MP3 vào hệ thống tệp cục bộ
    final tempDir = await getTemporaryDirectory();
    String mp3FilePath = path.join(tempDir.path, 'temp_song.mp3');
    final File mp3File = File(mp3FilePath);
    await mp3File.writeAsBytes(response.bodyBytes);
    print('MP3 file path: $mp3FilePath');

    // Đường dẫn lưu tệp lời bài hát
    String outputFilePath = path.join(tempDir.path, 'lyrics.srt');

    // Lệnh FFmpeg
    final command = '-i "$mp3FilePath" -vn "$outputFilePath"'; // Sử dụng 'subtitles' để trích xuất lời bài hát
    print('Running FFmpeg command: $command'); // In lệnh

    // Trích xuất lời bài hát bằng FFmpeg
    final session = await FFmpegKit.execute(command);

    // Kiểm tra kết quả của phiên FFmpeg
    final returnCode = await session.getReturnCode();
    print('Return Code: $returnCode'); // In mã trả về

    if (ReturnCode.isSuccess(returnCode)) {
      // Đọc lyrics từ file
      final lyricsFile = File(outputFilePath);
      if (await lyricsFile.exists()) {
        String lyrics = await lyricsFile.readAsString();
        print('Lyrics: $lyrics');
        return lyrics; // Trả về lời bài hát đã trích xuất
      } else {
        print('File lyrics.srt không tồn tại.');
        return 'Không tìm thấy tệp lời bài hát.';
      }
    } else {
      // In thêm thông tin lỗi từ FFmpeg nếu có
      print('Lỗi khi trích xuất lời bài hát. Vui lòng kiểm tra tệp MP3');
      final sessionLogs = await session.getOutput();
      print('FFmpeg Log Output: $sessionLogs');
      return 'Lỗi khi trích xuất lời bài hát. Vui lòng kiểm tra tệp MP3';
    }
  } catch (e) {
    print('Exception: $e');
    return 'Lỗi: $e';
  }
}



}

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }


