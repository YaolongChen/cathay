import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../routing/router.dart';
import '../../../core/localization/localization.dart';
import '../controller/playlist_controller.dart';
import 'playlist_create_sheet.dart';

class PlaylistAppBar extends ConsumerWidget {
  const PlaylistAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(playlistControllerProvider);

    final actions = <Widget>[];
    if (state.hasValue) {
      final value = state.requireValue;
      actions.addAll(
        value.editing
            ? [
              TextButton(
                onPressed:
                    value.appBarDeleteButtonActive
                        ? ref
                            .read(playlistControllerProvider.notifier)
                            .deleteCheckedPlaylists
                        : null,
                child: Text(AppLocalization.of(context).delete),
              ),
              TextButton(
                onPressed:
                    ref.read(playlistControllerProvider.notifier).toggleEditing,
                child: Text(AppLocalization.of(context).cancel),
              ),
            ]
            : [
              IconButton(
                onPressed:
                    value.appBarEditingButtonActive
                        ? ref
                            .read(playlistControllerProvider.notifier)
                            .toggleEditing
                        : null,
                icon: const Icon(Icons.checklist_rtl),
              ),
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: rootNavigatorKey.currentContext!,
                    builder: (context) => const RepaintBoundary(
                      child: PlaylistCreateSheet(),
                    ),
                  );
                },
                tooltip: AppLocalization.of(context).playlistCreateSheetTitle,
                icon: const Icon(Icons.add),
              ),
            ],
      );
    }

    return AppBar(
      title: Text(AppLocalization.of(context).playlistTitle),
      actions: state.map(
        data: (data) {
          return actions;
        },
        error: (error) {
          if (error.hasValue) {
            return actions;
          }

          return null;
        },
        loading: (loading) {
          if (loading.hasValue) {
            return actions;
          }

          return null;
        },
      ),
    );
  }
}
