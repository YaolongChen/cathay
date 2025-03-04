import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../config/dependencies.dart';
import '../../../../domain/entity/playlist/playlist.dart';
import '../state/playlist_state.dart';

part 'playlist_controller.g.dart';

@riverpod
class PlaylistController extends _$PlaylistController {
  @override
  Future<PlaylistState> build() async {
    final entities = await ref.read(playlistRepositoryProvider).getPlaylists();
    return PlaylistState(
      playlists: entities.map((e) => (entity: e, checked: false)).toList(),
    );
  }

  void reload() {
    ref.invalidateSelf();
  }

  Future<void> toggleEditing() async {
    final previousState = await future;
    final newEditing = !previousState.editing;

    state = await AsyncValue.guard(() {
      return Future.value(
        newEditing
            ? previousState.copyWith(editing: newEditing)
            : previousState.copyWith(
              editing: newEditing,
              playlists:
                  previousState.playlists
                      .map((e) => (entity: e.entity, checked: false))
                      .toList(),
            ),
      );
    });
  }

  Future<void> createPlaylist(String playlistName) async {
    final previousState = await future;

    final playlistRepository = ref.read(playlistRepositoryProvider);

    state = await AsyncValue.guard(() async {
      var entity = Playlist.create(playlistName);
      final id = await playlistRepository.savePlaylist(entity);
      entity = entity.copyWith(id: id);
      final newPlaylists = [
        ...previousState.playlists,
        (entity: entity, checked: false),
      ];
      return previousState.copyWith(playlists: newPlaylists);
    });
  }

  void toggleItemChecked(UiPlaylist item) {
    final previousState = state.value!;
    final index = previousState.playlists.indexWhere(
      (e) => e.entity.id == item.entity.id,
    );
    if (!index.isNegative) {
      final newPlaylists = List.of(previousState.playlists)
        ..setAll(index, [(entity: item.entity, checked: !item.checked)]);
      state = AsyncData(previousState.copyWith(playlists: newPlaylists));
    }
  }

  Future<void> deleteCheckedPlaylists() async {
    final preState = await future;

    final checkedPlaylists =
        preState.playlists
            .where((e) => e.checked)
            .map((e) => e.entity.id!)
            .toList();

    if (checkedPlaylists.isNotEmpty) {
      final playlistRepository = ref.read(playlistRepositoryProvider);

      state = await AsyncValue.guard(() async {
        await playlistRepository.removePlaylistByIds(checkedPlaylists);
        final entities = await playlistRepository.getPlaylists();
        return PlaylistState(
          playlists: entities.map((e) => (entity: e, checked: false)).toList(),
          editing: false,
        );
      });
    }
  }
}
