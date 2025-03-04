import 'package:freezed_annotation/freezed_annotation.dart';

import '../../exception/playlist_exception.dart';

part 'playlist_name.freezed.dart';

@freezed
abstract class PlaylistName with _$PlaylistName {
  static const maxLength = 20;

  const factory PlaylistName(String value) = _PlaylistName;

  factory PlaylistName.create(String input) {
    _validate(input);
    return PlaylistName(input.trim());
  }

  static void _validate(String input) {
    if (input.trim().isEmpty) {
      throw const PlaylistException.nameEmpty();
    }
    if (input.trim().length > maxLength) {
      throw const PlaylistException.nameTooLong();
    }
  }
}
