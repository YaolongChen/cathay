import 'dart:async';

import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';

import '../../domain/aggregate/playlist_aggregate.dart';
import '../../domain/entity/playlist/playlist.dart';
import '../../domain/entity/song/song.dart';
import '../../domain/repository/i_playlist_repository.dart';
import '../../domain/value_object/file_size/file_size.dart';
import '../../domain/value_object/playlist_name/playlist_name.dart';
import '../data_source/drift_playlist_data_source.dart';
import '../drift/app_database.dart';

class PlaylistRepositoryImpl implements IPlaylistRepository {
  PlaylistRepositoryImpl({
    required DriftPlaylistDataSource driftDataSource,
    required Uuid uuid,
  }) : _drift = driftDataSource,
       _uuid = uuid;

  final _log = Logger('PlaylistRepository');
  final DriftPlaylistDataSource _drift;
  final Uuid _uuid;

  @override
  Future<List<Playlist>> getPlaylists() async {
    try {
      final dtoList = await _drift.getPlaylists();
      return dtoList.map((dto) {
        final localPlaylist = dto.playlist;
        return Playlist(
          id: localPlaylist.id,
          name: PlaylistName(localPlaylist.name),
          coverUri:
              localPlaylist.coverUri != null
                  ? Uri.tryParse(localPlaylist.coverUri!)
                  : null,
          songs: dto.songIds,
        );
      }).toList();
    } catch (e, s) {
      _log.warning('getPlaylists failed', e, s);
      rethrow;
    }
  }

  @override
  Future<PlaylistAggregate> getPlaylistById(PlaylistId id) async {
    try {
      final dto = await _drift.getPlaylistById(id);
      final localPlaylist = dto.playlist;
      final localSongs = dto.songs;

      final playlist = Playlist(
        id: localPlaylist.id,
        name: PlaylistName(localPlaylist.name),
        coverUri:
            localPlaylist.coverUri != null
                ? Uri.tryParse(localPlaylist.coverUri!)
                : null,
        songs: localSongs.map((e) => e.id).toList(),
      );

      final songs =
          localSongs
              .map(
                (e) => Song(
                  id: e.id,
                  name: e.name,
                  duration: Duration(milliseconds: e.duration.toInt()),
                  artist: e.artist,
                  size: FileSize(bytes: e.size.toInt()),
                  uri: Uri.parse(e.uri),
                  albumUri: Uri.parse(e.albumUri),
                ),
              )
              .toList();

      return PlaylistAggregate(playlist: playlist, songs: songs);
    } catch (e, s) {
      _log.warning('getPlaylistById failed. id is $id', e, s);
      rethrow;
    }
  }

  @override
  Future<PlaylistId?> savePlaylist(Playlist playlist) async {
    try {
      if (playlist.id == null) {
        final id = _uuid.v7();
        await _drift.insertPlaylist(
          LocalPlaylist(
            id: id,
            name: playlist.name.value,
            coverUri: playlist.coverUri?.toString(),
          ),
        );
        return id;
      } else {
        await _drift.updatePlaylistWithSongIds(
          LocalPlaylistWithSongIdsDto(
            playlist: LocalPlaylist(
              id: playlist.id!,
              name: playlist.name.value,
              coverUri: playlist.coverUri?.toString(),
            ),
            songIds: playlist.songs,
          ),
        );
        return null;
      }
    } catch (e, s) {
      _log.warning('savePlaylist failed. playlist is $playlist', e, s);
      rethrow;
    }
  }

  @override
  Future<void> removePlaylistByIds(List<PlaylistId> ids) {
    try {
      return _drift.deletePlaylistByIdBatch(ids);
    } catch (e, s) {
      _log.warning('removePlaylistByIds failed. ids is $ids', e, s);
      rethrow;
    }
  }

  @override
  Future<void> removePlaylistSongById(PlaylistId playlistId, SongId songId) {
    try {
      return _drift.deletePlaylistSongRelation(
        LocalPlaylistSong(playlistId: playlistId, songId: songId),
      );
    } catch (e, s) {
      _log.warning(
        'removePlaylistSongById failed. playlistId is $playlistId, songId is $songId',
        e,
        s,
      );
      rethrow;
    }
  }
}
