import 'package:logging/logging.dart';

import '../../domain/entity/song/song.dart';
import '../../domain/value_object/file_size/file_size.dart';
import '../data_source/drift_song_data_source.dart';
import '../data_source/media_store_song_data_source.dart';
import '../drift/app_database.dart';
import '../kv_store/kv_store.dart';

class SongRepository {
  final _log = Logger('SongRepository');
  final DriftSongDataSource _drift;
  final MediaStoreSongDataSource _mediaStore;
  final KVStore _kvStore;

  SongRepository({
    required DriftSongDataSource driftSongDataSource,
    required MediaStoreSongDataSource mediaStoreSongDataSource,
    required KVStore kvStore,
  }) : _drift = driftSongDataSource,
       _mediaStore = mediaStoreSongDataSource,
       _kvStore = kvStore;

  Future<List<Song>> getLocalSongs() async {
    try {
      final audios = await _mediaStore.getAudios();
      final songs =
          audios
              .map(
                (e) => Song(
                  id: e.id.toString(),
                  name: e.name,
                  duration: e.duration,
                  artist: e.artist,
                  size: FileSize(bytes: e.size),
                  uri: e.uri,
                  albumUri: e.albumUri,
                ),
              )
              .toList();
      final localSongs =
          audios
              .map(
                (e) => LocalSong(
                  id: e.id.toString(),
                  name: e.name,
                  duration: BigInt.from(e.duration.inMilliseconds),
                  artist: e.artist,
                  size: BigInt.from(e.size),
                  uri: e.uri.toString(),
                  albumUri: e.albumUri.toString(),
                ),
              )
              .toList();

      await _drift.saveSongs(localSongs);
      return songs;
    } catch (e, s) {
      _log.warning('getLocalSongs error. ${e.toString()}', e, s);
      rethrow;
    }
  }
}
