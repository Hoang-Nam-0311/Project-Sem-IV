import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spotify_app/presentation/song_player/bloc/song_player_state.dart';

class SongPlayerCubit extends Cubit<SongPlayerState> {
  final AudioPlayer audioPlayer = AudioPlayer();

  List<String> songList = []; // Danh sách URL bài hát
  int currentIndex = 0; // Vị trí bài hát hiện tại

  Duration songDuration = Duration.zero;
  Duration songPosition = Duration.zero;

  // Khởi tạo Cubit
  SongPlayerCubit() : super(SongPlayerLoading()) {
    // Lắng nghe vị trí bài hát
    audioPlayer.positionStream.listen((position) {
      songPosition = position;
      updateSongPlayer();
    });

    // Lắng nghe thời gian bài hát
    audioPlayer.durationStream.listen((duration) {
      if (duration != null) {
        songDuration = duration;
        updateSongPlayer(); // Cập nhật trạng thái khi có thời gian
      } else {
        print("Error: Song duration is null");
      }
    });
  }

  // Cập nhật trạng thái của player
  void updateSongPlayer() {
    emit(SongPlayerLoaded(
      duration: songDuration,
      position: songPosition,
      isPlaying: audioPlayer.playing,
      currentSongUrl: songList.isNotEmpty ? songList[currentIndex] : '',
    ));
  }

  // Tải một bài hát từ URL
  Future<void> loadSong(String url) async {
    try {
      await audioPlayer.stop();
      print("Loading song from URL: $url");
      await audioPlayer.setUrl(url);
      await audioPlayer.play();

      emit(SongPlayerLoaded(
        duration: songDuration,
        position: Duration.zero,
        isPlaying: true,
        currentSongUrl: url,
      ));
    } catch (e) {
      emit(SongPlayerFailure(message: "Error loading song: $e"));
      print("Error loading song: $e");
    }
  }

  // Phát hoặc tạm dừng bài hát
  void playOrPauseSong() {
    if (audioPlayer.playing) {
      audioPlayer.pause();
    } else {
      audioPlayer.play();
    }
    updateSongPlayer();
  }

  // Chuyển đến bài hát tiếp theo
  void nextSong() {
    print("Next song pressed");
    print("Current index: $currentIndex");
    print("Song list: $songList");

    if (songList.isEmpty) {
      print("Song list is empty");
      emit(SongPlayerFailure(message: "Danh sách bài hát trống"));
      return;
    }

    currentIndex = (currentIndex + 1) % songList.length;
    loadSong(songList[currentIndex]).then((_) {
      updateSongPlayer();
      print("Song updated to: ${songList[currentIndex]}");
    }).catchError((e) {
      print("Error moving to next song: $e");
      emit(SongPlayerFailure(message: "Error moving to next song: $e"));
    });
  }

  // Chuyển đến bài hát trước đó
  void previousSong() {
    print("Previous song pressed");
    print("Current index: $currentIndex");

    if (songList.isEmpty) {
      print("Song list is empty");
      emit(SongPlayerFailure(message: "Danh sách bài hát trống"));
      return;
    }

    currentIndex = (currentIndex - 1 + songList.length) % songList.length;
    loadSong(songList[currentIndex]).then((_) {
      updateSongPlayer();
      print("Song updated to: ${songList[currentIndex]}");
    }).catchError((e) {
      print("Error moving to previous song: $e");
      emit(SongPlayerFailure(message: "Error moving to previous song: $e"));
    });
  }

  // Thiết lập danh sách bài hát
  void setSongList(List<String> songs) {
    print("Đang thiết lập danh sách bài hát...");

    if (songs.isNotEmpty) {
      songList = songs;
      currentIndex = 0; // Bắt đầu từ bài hát đầu tiên
      loadSong(songList[currentIndex]); // Tải bài hát đầu tiên
      print(
          "Danh sách bài hát đã được thiết lập với ${songList.length} bài hát");
      print("Danh sách bài hát hiện tại: ${songList.join(', ')}");

      emit(SongPlayerInitialized());
    } else {
      print("Danh sách bài hát trống");
      emit(SongPlayerFailure(message: "Danh sách bài hát trống"));
    }
  }

  // Lấy danh sách bài hát từ Firebase
  Future<void> fetchSongsFromFirebase() async {
    try {
      // Lấy dữ liệu từ Firestore
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('songs').get();

      // Chuyển đổi dữ liệu thành danh sách URL
      List<String> songs =
          snapshot.docs.map((doc) => doc['url'] as String).toList();

      // Thiết lập danh sách bài hát
      setSongList(songs);
    } catch (e) {
      print("Error fetching songs from Firebase: $e");
      emit(
          SongPlayerFailure(message: "Error fetching songs from Firebase: $e"));
    }
  }

  @override
  Future<void> close() {
    audioPlayer.dispose();
    return super.close();
  }
}
