import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/routes.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/dimens.dart';
import '../../../widget/loading_error_view.dart';
import '../../../widget/loading_view.dart';
import '../controller/playlist_controller.dart';
import '../state/playlist_state.dart';
import 'playlist_list_item_view.dart';

class PlaylistListView extends ConsumerWidget {
  const PlaylistListView({super.key});

  Future<void> _toDetail(
    WidgetRef ref,
    BuildContext context,
    UiPlaylist item,
  ) async {
    final coverUri = item.entity.coverUri;
    await ref
        .read(playlistCoverColorSchemeProvider.notifier)
        .updateCover(coverUri);
    if (context.mounted) {
      context.go(Routes.playlistWithId(item.entity.id!));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(playlistControllerProvider);

    if (state.hasValue) {
      final value = state.requireValue;
      const spacing = Dimens.spacingSmall;

      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,
        ),
        itemBuilder: (context, index) {
          final item = value.playlists[index];
          return PlaylistListItemView(
            key: ValueKey(item.entity.id),
            playlist: item,
            editing: value.editing,
            onTap: () {
              if (value.editing) {
                ref
                    .read(playlistControllerProvider.notifier)
                    .toggleItemChecked(item);
              } else {
                _toDetail(ref, context, item);
              }
            },
            onLongPress:
                value.editing
                    ? null
                    : () async {
                      await ref
                          .read(playlistControllerProvider.notifier)
                          .toggleEditing();
                      ref
                          .read(playlistControllerProvider.notifier)
                          .toggleItemChecked(item);
                    },
          );
        },
        itemCount: value.playlists.length,
      );
    }

    if (state.hasError) {
      return LoadingErrorView(
        onReloadTap: ref.read(playlistControllerProvider.notifier).reload,
      );
    }

    return const LoadingView();
  }
}
