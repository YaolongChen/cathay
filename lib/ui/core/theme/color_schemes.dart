import 'dart:io';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'color_schemes.g.dart';

@Riverpod(keepAlive: true)
class PlaylistCoverColorScheme extends _$PlaylistCoverColorScheme {
  @override
  FutureOr<ColorScheme?> build() {
    return Future.value(null);
  }

  Future<void> updateCover(Uri? coverUri) async {
    await future;

    state = await AsyncValue.guard(() async {
      if (coverUri == null) {
        return null;
      }

      ColorScheme? colorScheme;
      try {
        final fileImage = FileImage(File.fromUri(coverUri));
        colorScheme = await ColorScheme.fromImageProvider(provider: fileImage);
        return colorScheme;
      } catch (e) {
        return null;
      }
    });
  }
}
