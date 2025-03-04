import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../domain/entity/song/song.dart';

part 'local_song_state.freezed.dart';

@freezed
abstract class LocalSongState with _$LocalSongState {
  const LocalSongState._();

  const factory LocalSongState({
    @Default(<Song>[]) List<Song> songs,
    @Default(<SongId>{}) Set<SongId> selectedSongIds,
  }) = _LocalSongState;

  List<Song> get selectedSongs =>
      songs.where((e) => selectedSongIds.contains(e.id)).toList();
}
