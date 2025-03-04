import 'package:drift/drift.dart';

import 'playlists.dart';
import 'songs.dart';

@DataClassName('LocalPlaylistSong')
class PlaylistSongRelations extends Table {
  TextColumn get playlistId =>
      text().references(Playlists, #id, onDelete: KeyAction.cascade)();

  TextColumn get songId =>
      text().references(Songs, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {playlistId, songId};
}
