import 'dart:math' as math;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'file_size.freezed.dart';

@freezed
abstract class FileSize with _$FileSize {
  const factory FileSize({required int bytes}) = _FileSize;

  @override
  String toString() {
    return switch (bytes) {
      < 1024 => '${bytes}B',
      < 1024 * 1024 => '${bytes / 1024}.${bytes % 1024}KB',
      < 1024 * 1024 * 1024 =>
        '${bytes / math.pow(1024, 2)}.${bytes % math.pow(1024, 2)}MB',
      _ => '${bytes / math.pow(1024, 3)}.${bytes % math.pow(1024, 3)}GB',
    };
  }
}
