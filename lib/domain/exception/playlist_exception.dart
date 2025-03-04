sealed class PlaylistException implements Exception {
  const PlaylistException();

  const factory PlaylistException.nameEmpty() = PlaylistNameEmptyException._;

  const factory PlaylistException.nameTooLong() =
      PlaylistNameTooLongException._;
}

final class PlaylistNameEmptyException extends PlaylistException {
  const PlaylistNameEmptyException._();

  @override
  String toString() {
    return 'PlaylistNameEmptyException{}';
  }
}

final class PlaylistNameTooLongException extends PlaylistException {
  const PlaylistNameTooLongException._();

  @override
  String toString() {
    return 'PlaylistNameTooLongException{}';
  }
}
