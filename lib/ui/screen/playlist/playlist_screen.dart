import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../routing/routes.dart';
import '../player/widget/bottom_player_bar.dart';
import 'controller/playlist_controller.dart';

class PlaylistScreen extends ConsumerWidget {
  const PlaylistScreen({
    super.key,
    required this.child,
    required this.routePath,
  });

  final Uri routePath;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (routePath.path == Routes.playlist) {
          final state = ref.read(playlistControllerProvider);
          if (!didPop && state.value?.editing == true) {
            ref.read(playlistControllerProvider.notifier).toggleEditing();
          }
        }
      },
      child: Scaffold(
        body: child,
        bottomNavigationBar: const BottomPlayerBar(),
      ),
    );
  }
}
