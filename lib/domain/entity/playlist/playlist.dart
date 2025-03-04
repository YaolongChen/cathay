import 'package:freezed_annotation/freezed_annotation.dart';

import '../../value_object/playlist_name/playlist_name.dart';
import '../song/song.dart';

part 'playlist.freezed.dart';

part 'playlist.g.dart';

typedef PlaylistId = String;

@freezed
abstract class Playlist with _$Playlist {
  const Playlist._();

  const factory Playlist({
    PlaylistId? id,
    @_PlaylistNameJsonConverter() required PlaylistName name,
    Uri? coverUri,
    @Default(<SongId>[]) List<SongId> songs,
  }) = _Playlist;

  factory Playlist.create(String name) {
    return Playlist(name: PlaylistName.create(name));
  }

  factory Playlist.fromJson(Map<String, dynamic> json) =>
      _$PlaylistFromJson(json);
}

class _PlaylistNameJsonConverter extends JsonConverter<PlaylistName, String> {
  const _PlaylistNameJsonConverter();

  @override
  PlaylistName fromJson(String json) {
    return PlaylistName.create(json);
  }

  @override
  String toJson(PlaylistName object) {
    return object.value;
  }
}
