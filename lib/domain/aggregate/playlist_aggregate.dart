import 'package:freezed_annotation/freezed_annotation.dart';

import '../entity/playlist/playlist.dart';
import '../entity/song/song.dart';

part 'playlist_aggregate.freezed.dart';

part 'playlist_aggregate.g.dart';

@freezed
abstract class PlaylistAggregate with _$PlaylistAggregate {
  const PlaylistAggregate._();

  const factory PlaylistAggregate({
    required Playlist playlist,
    required List<Song> songs,
  }) = _PlaylistAggregate;

  factory PlaylistAggregate.fromJson(Map<String, dynamic> json) =>
      _$PlaylistAggregateFromJson(json);

  PlaylistAggregate addSongs(List<Song> songs) {
    final playlist = this.playlist;
    return copyWith(
      songs: [...this.songs, ...songs],
      playlist: playlist.copyWith(
        songs: [...playlist.songs, ...songs.map((e) => e.id)],
      ),
    );
  }

  PlaylistAggregate removeSong(SongId songId) {
    final songs = List.of(this.songs)..removeWhere((e) => e.id == songId);
    return copyWith(songs: songs);
  }
}
