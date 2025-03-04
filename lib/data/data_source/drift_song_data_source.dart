import 'package:drift/drift.dart';

import '../drift/app_database.dart';

class DriftSongDataSource {
  DriftSongDataSource({required this.db});

  final AppDatabase db;

  Future<List<LocalSong>> getSongs() {
    return db.songs.all().get();
  }

  Future<void> saveSongs(List<LocalSong> songs) {
    return db.songs.insertAll(
      songs,
      onConflict: UpsertMultiple(
        songs
            .map(
              (song) => DoUpdate<$SongsTable, LocalSong>(
                (old) => song,
                where: (t) => t.id.equals(song.id),
              ),
            )
            .toList(),
      ),
    );
  }

  Future<int> deleteSongById(String id) {
    return db.songs.deleteWhere((t) => t.id.equals(id));
  }
}
