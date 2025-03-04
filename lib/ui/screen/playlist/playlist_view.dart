import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/exception/playlist_exception.dart';
import '../../core/localization/localization.dart';
import '../../core/theme/dimens.dart';
import 'controller/playlist_controller.dart';
import 'widget/playlist_app_bar.dart';
import 'widget/playlist_list_view.dart';

class PlaylistView extends ConsumerWidget {
  const PlaylistView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(playlistControllerProvider, (previous, next) {
      if (next.hasError) {
        final error = next.error;
        String? msg;
        if (error is PlaylistNameTooLongException) {
          msg = AppLocalization.of(context).playlistNameTooLongTip;
        } else if (error is PlaylistNameEmptyException) {
          msg = AppLocalization.of(context).playlistNameEmptyTip;
        } else {
          msg = AppLocalization.of(context).unknownErrorTip;
        }

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(msg)));
      }
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: PlaylistAppBar(),
      ),
      body: Padding(
        padding: Dimens.edgeInsetsScreenHorizontal,
        child: const PlaylistListView(),
      ),
    );
  }
}
