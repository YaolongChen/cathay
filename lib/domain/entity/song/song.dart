import 'package:freezed_annotation/freezed_annotation.dart';

import '../../value_object/file_size/file_size.dart';

part 'song.freezed.dart';

part 'song.g.dart';

typedef SongId = String;

@freezed
abstract class Song with _$Song {
  const factory Song({
    required SongId id,
    required String name,
    required Duration duration,
    required String artist,
    @_FileSizeJsonConvert() required FileSize size,
    required Uri uri,
    required Uri albumUri,
  }) = _Song;

  factory Song.fromJson(Map<String, dynamic> json) => _$SongFromJson(json);
}

class _FileSizeJsonConvert extends JsonConverter<FileSize, String> {
  const _FileSizeJsonConvert();

  @override
  FileSize fromJson(String json) {
    return FileSize(bytes: int.parse(json));
  }

  @override
  String toJson(FileSize object) {
    return object.bytes.toString();
  }
}
