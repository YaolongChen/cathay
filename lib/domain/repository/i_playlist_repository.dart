import '../aggregate/playlist_aggregate.dart';
import '../entity/playlist/playlist.dart';
import '../entity/song/song.dart';

abstract interface class IPlaylistRepository {
  Future<List<Playlist>> getPlaylists();

  Future<PlaylistAggregate> getPlaylistById(PlaylistId id);

  Future<PlaylistId?> savePlaylist(Playlist playlist);

  Future<void> removePlaylistByIds(List<PlaylistId> ids);

  Future<void> removePlaylistSongById(PlaylistId playlistId, SongId id);
}
