import 'package:drift/drift.dart';

import '../drift/app_database.dart';
import '../drift/table/playlist_song_relations.dart';

class LocalPlaylistWithSongIdsDto {
  final LocalPlaylist playlist;
  final List<String> songIds;

  LocalPlaylistWithSongIdsDto({required this.playlist, required this.songIds});
}

class LocalPlaylistWithSongsDto {
  final LocalPlaylist playlist;
  final List<LocalSong> songs;

  LocalPlaylistWithSongsDto({required this.playlist, required this.songs});
}

class DriftPlaylistDataSource {
  DriftPlaylistDataSource({required this.db});

  final AppDatabase db;

  Future<List<LocalPlaylistWithSongIdsDto>> getPlaylists() async {
    final query = db.select(db.playlists).join([
      leftOuterJoin(
        db.playlistSongRelations,
        db.playlistSongRelations.playlistId.equalsExp(db.playlists.id),
      ),
    ]);
    final rows = await query.get();

    final playlistMap = <String, LocalPlaylist>{};
    final songIdsMap = <String, List<String>>{};

    for (final row in rows) {
      final playlist = row.readTable(db.playlists);
      playlistMap.putIfAbsent(playlist.id, () => playlist);
      final songId = row.read(db.playlistSongRelations.songId);
      if (songId != null) {
        songIdsMap.putIfAbsent(playlist.id, () => []).add(songId);
      }
    }

    return playlistMap.entries.map((entry) {
      return LocalPlaylistWithSongIdsDto(
        playlist: entry.value,
        songIds: songIdsMap[entry.key] ?? [],
      );
    }).toList();
  }

  Future<LocalPlaylistWithSongsDto> getPlaylistById(String id) async {
    final playlistQuery = db.select(db.playlists)
      ..where((t) => t.id.equals(id));

    final songsQuery = db.select(db.playlistSongRelations).join([
      leftOuterJoin(
        db.songs,
        db.songs.id.equalsExp(db.playlistSongRelations.songId),
      ),
    ])..where(db.playlistSongRelations.playlistId.equals(id));

    final playlist = await playlistQuery.getSingle();
    final songsQueryResult = await songsQuery.get();
    final songs =
        songsQueryResult.map((row) => row.readTable(db.songs)).toList();
    return LocalPlaylistWithSongsDto(playlist: playlist, songs: songs);
  }

  Future<int> insertPlaylist(LocalPlaylist playlist) {
    return db.playlists.insertOne(playlist, mode: InsertMode.replace);
  }

  Future<void> updatePlaylistWithSongIds(LocalPlaylistWithSongIdsDto dto) {
    return db.transaction(() async {
      final playlist = dto.playlist;
      final relations = dto.songIds.map(
        (id) => LocalPlaylistSong(playlistId: playlist.id, songId: id),
      );

      final updateQuery =
          db.playlists.update()..where((t) => t.id.equals(playlist.id));
      await updateQuery.write(
        PlaylistsCompanion(
          id: const Value.absent(),
          name: Value(playlist.name),
          coverUri: Value(playlist.coverUri),
        ),
      );
      return db.playlistSongRelations.insertAll(
        relations,
        mode: InsertMode.insertOrIgnore,
      );
    });
  }

  Future<void> deletePlaylistByIdBatch(List<String> ids) {
    return db.batch((batch) {
      for (final id in ids) {
        batch.deleteWhere(db.playlists, (t) => t.id.equals(id));
      }
    });
  }

  Future<void> deletePlaylistSongRelation(LocalPlaylistSong relation) {
    return db.playlistSongRelations.deleteOne(relation);
  }
}
