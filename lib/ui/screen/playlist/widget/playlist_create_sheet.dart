import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../domain/value_object/playlist_name/playlist_name.dart';
import '../../../core/localization/localization.dart';
import '../../../core/theme/dimens.dart';
import '../controller/playlist_controller.dart';

class PlaylistCreateSheet extends ConsumerStatefulWidget {
  const PlaylistCreateSheet({super.key});

  @override
  ConsumerState<PlaylistCreateSheet> createState() =>
      _PlaylistCreateSheetState();
}

class _PlaylistCreateSheetState extends ConsumerState<PlaylistCreateSheet> {
  final _playlistName = TextEditingController();

  @override
  void dispose() {
    _playlistName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          leading: const CloseButton(),
          actions: [
            ValueListenableBuilder(
              valueListenable: _playlistName,
              builder: (context, value, child) {
                final isActive = value.text.isNotEmpty;
                return IconButton(
                  onPressed:
                      isActive
                          ? () {
                            ref
                                .read(playlistControllerProvider.notifier)
                                .createPlaylist(_playlistName.text)
                                .then((_) {
                                  if (context.mounted) {
                                    context.pop();
                                  }
                                });
                          }
                          : null,
                  color: isActive ? Theme.of(context).primaryColor : null,
                  icon: child!,
                  tooltip: AppLocalization.of(context).check,
                );
              },
              child: const Icon(Icons.check),
            ),
          ],
          title: Text(AppLocalization.of(context).playlistCreateSheetTitle),
        ),
        Flexible(
          child: SingleChildScrollView(
            padding: Dimens.edgeInsetsScreenHorizontal.copyWith(
              bottom: MediaQuery.viewInsetsOf(context).bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  controller: _playlistName,
                  maxLength: PlaylistName.maxLength,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: AppLocalization.of(context).playlistNameHintText,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
