import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../config/dependencies.dart';
import '../../../../domain/aggregate/playlist_aggregate.dart';
import '../../../../domain/entity/playlist/playlist.dart';
import '../../../../domain/entity/song/song.dart';
import '../../../core/theme/color_schemes.dart';
import '../../playlist/controller/playlist_controller.dart';

part 'playlist_detail_controller.g.dart';

@riverpod
class PlaylistDetailController extends _$PlaylistDetailController {
  @override
  Future<PlaylistAggregate> build(PlaylistId id) async {
    final playlist = await ref
        .read(playlistRepositoryProvider)
        .getPlaylistById(id);

    return playlist;
  }

  void reload() {
    ref.invalidateSelf();
  }

  Future<void> setPlaylistCover() async {
    final previousState = await future;
    final coverUri =
        await ref.read(imageFileDataSourceProvider).getSingleImageFromGallery();
    final playlistRepository = ref.read(playlistRepositoryProvider);

    if (coverUri != null) {
      state = await AsyncValue.guard(() async {
        final nextState = previousState.copyWith.playlist(coverUri: coverUri);
        await playlistRepository.savePlaylist(nextState.playlist);
        return nextState;
      });
    }
  }

  Future<void> addSong(List<Song> songs) async {
    if (songs.isEmpty) {
      return;
    }

    final preState = await future;
    final nextState = preState.addSongs(songs);

    state = await AsyncValue.guard(() async {
      await ref
          .read(playlistRepositoryProvider)
          .savePlaylist(nextState.playlist);
      return nextState;
    });
  }

  Future<void> removeSongFromPlaylist(SongId songId) async {
    final preState = await future;
    final repository = ref.read(playlistRepositoryProvider);
    state = await AsyncValue.guard(() async {
      await repository.removePlaylistSongById(id, songId);
      return preState.removeSong(songId);
    });
  }
}
