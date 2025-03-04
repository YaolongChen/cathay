import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../config/dependencies.dart';
import '../../../../domain/entity/song/song.dart';
import '../state/local_song_state.dart';

part 'local_songs_controller.g.dart';

@riverpod
class LocalSongsController extends _$LocalSongsController {
  @override
  FutureOr<LocalSongState> build() async {
    final sysPermissionRepository = ref.read(sysPermissionRepositoryProvider);
    final havePermission =
        await sysPermissionRepository.checkReadAudioPermission();
    if (!havePermission) {
      await sysPermissionRepository.requestReadAudioPermission();
    }

    final songRepository = ref.read(songRepositoryProvider);
    final songs = await songRepository.getLocalSongs();
    return LocalSongState(songs: songs);
  }

  Future<void> toggleItem(Song song) async {
    final preState = await future;
    final selectedSongIds = Set.of(preState.selectedSongIds);
    if (selectedSongIds.contains(song.id)) {
      selectedSongIds.remove(song.id);
    } else {
      selectedSongIds.add(song.id);
    }
    state = AsyncData(preState.copyWith(selectedSongIds: selectedSongIds));
  }
}
