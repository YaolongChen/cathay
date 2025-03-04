abstract final class Routes {
  static const playlist = '/playlist';
  static const localSong = '/localSong';

  static String playlistWithId(String id) => '$playlist/$id';
}
