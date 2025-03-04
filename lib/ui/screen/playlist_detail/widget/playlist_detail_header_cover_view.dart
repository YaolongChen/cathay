import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/entity/playlist/playlist.dart';
import '../../../core/localization/localization.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/dimens.dart';
import '../../playlist/controller/playlist_controller.dart';
import '../controller/playlist_detail_controller.dart';

class PlaylistDetailHeaderCoverView extends ConsumerWidget {
  const PlaylistDetailHeaderCoverView({super.key, required this.id});

  final PlaylistId id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncCoverUri = ref.watch(
      playlistDetailControllerProvider(
        id,
      ).selectAsync((state) => state.playlist.coverUri),
    );

    const borderRadius = BorderRadius.all(Dimens.cornerSmall);

    return FutureBuilder(
      future: asyncCoverUri,
      builder: (context, snapShot) {
        final coverUri = snapShot.data;
        return Card(
          clipBehavior: Clip.hardEdge,
          shape: const RoundedRectangleBorder(borderRadius: borderRadius),
          child:
              coverUri == null
                  ? Tooltip(
                    message:
                        AppLocalization.of(
                          context,
                        ).playlistDetailAddCoverToolTip,
                    child: SizedBox(
                      width: Dimens.profilePictureSize,
                      height: Dimens.profilePictureSize,
                      child: InkWell(
                        borderRadius: borderRadius,
                        onTap: () {
                          ref
                              .read(
                                playlistDetailControllerProvider(id).notifier,
                              )
                              .setPlaylistCover();
                          ref.invalidate(playlistControllerProvider);
                          ref
                              .read(playlistCoverColorSchemeProvider.notifier)
                              .updateCover(coverUri);
                        },
                        child: const Center(child: Icon(Icons.add)),
                      ),
                    ),
                  )
                  : Image.file(
                    File.fromUri(coverUri),
                    fit: BoxFit.cover,
                    width: Dimens.profilePictureSize,
                    height: Dimens.profilePictureSize,
                  ),
        );
      },
    );
  }
}
