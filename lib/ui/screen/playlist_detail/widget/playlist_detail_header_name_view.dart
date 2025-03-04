import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/entity/playlist/playlist.dart';
import '../controller/playlist_detail_controller.dart';

class PlaylistDetailHeaderNameView extends ConsumerWidget {
  const PlaylistDetailHeaderNameView({super.key, required this.id});

  final PlaylistId id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPlaylistName = ref.watch(
      playlistDetailControllerProvider(
        id,
      ).selectAsync((state) => state.playlist.name),
    );

    return FutureBuilder(
      future: asyncPlaylistName,
      builder: (context, snapShot) {
        if (snapShot.hasData) {
          final playlistName = snapShot.data;
          return Text(
            playlistName?.value ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium,
          );
        }

        return const SizedBox();
      },
    );
  }
}
