import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../domain/entity/playlist/playlist.dart';
import '../../../../domain/entity/song/song.dart';
import '../../../../routing/routes.dart';
import '../../../core/theme/color_schemes.dart';
import '../controller/playlist_detail_controller.dart';

class PlaylistDetailAppBar extends ConsumerWidget {
  const PlaylistDetailAppBar({super.key, required this.id});

  final PlaylistId id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coverColorScheme =
        ref.watch(playlistCoverColorSchemeProvider).valueOrNull ??
        ColorScheme.of(context);
    final playlist =
        ref.watch(playlistDetailControllerProvider(id)).valueOrNull;

    return AppBar(
      backgroundColor: coverColorScheme.inversePrimary,
      actions: [
        if (playlist?.songs.isNotEmpty == true)
          IconButton(
            onPressed: () async {
              final songs = await context.push<List<Song>>(
                Routes.localSong,
                extra: playlist?.songs.map((e) => e.id).toList(),
              );
              if (songs != null) {
                ref
                    .read(playlistDetailControllerProvider(id).notifier)
                    .addSong(songs);
              }
            },
            icon: const Icon(Icons.add),
          ),
      ],
    );
  }
}
