import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_app/domain/usecases/song/ranking_song.dart';
import 'package:spotify_app/presentation/home/bloc/ranking_songs_state.dart';
import 'package:spotify_app/service_locator.dart';

class RankingSongsCubit extends Cubit<RankingSongsState> {
  RankingSongsCubit() : super(RankingSongsLoading());

  Future<void> getRankingSongs() async {
    emit(RankingSongsLoading()); // Phát ra trạng thái Loading

    // Gọi UseCase để lấy danh sách bài hát đã xếp hạng
    var result = await sl<GetRankingSongsUseCase>().call();

    // Kiểm tra kết quả
    result.fold(
      (failure) {
        emit(RankingSongsLoadFailure()); // Nếu có lỗi, phát sinh lỗi
      },
      (songs) {
        emit(
            RankingSongsLoaded(songs: songs)); // Cập nhật danh sách đã xếp hạng
      },
    );
  }
}
