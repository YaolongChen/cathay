import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../domain/entity/playlist/playlist.dart';

part 'playlist_state.freezed.dart';

typedef UiPlaylist = ({Playlist entity, bool checked});

@freezed
abstract class PlaylistState with _$PlaylistState {
  const PlaylistState._();

  const factory PlaylistState({
    @Default(<UiPlaylist>[]) List<UiPlaylist> playlists,
    @Default(false) bool editing,
  }) = _PlaylistState;

  bool get appBarEditingButtonActive => playlists.isNotEmpty;

  bool get appBarDeleteButtonActive =>
      editing & playlists.any((e) => e.checked);
}
