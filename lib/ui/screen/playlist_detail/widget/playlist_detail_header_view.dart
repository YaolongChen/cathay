import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/entity/playlist/playlist.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/dimens.dart';
import 'playlist_detail_header_cover_view.dart';
import 'playlist_detail_header_name_view.dart';

class PlaylistDetailHeaderView extends ConsumerWidget {
  const PlaylistDetailHeaderView({super.key, required this.id});

  final PlaylistId id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coverColorScheme =
        ref.watch(playlistCoverColorSchemeProvider).valueOrNull;
    final themeData = Theme.of(context).copyWith(colorScheme: coverColorScheme);
    final padding = Dimens.edgeInsetsScreenHorizontal.copyWith(
      bottom: Dimens.padding16,
    );

    return Theme(
      data: themeData,
      child: Material(
        color: themeData.colorScheme.inversePrimary,
        child: Padding(
          padding: padding,
          child: Row(
            spacing: Dimens.spacingMedium,
            children: [
              PlaylistDetailHeaderCoverView(id: id),
              PlaylistDetailHeaderNameView(id: id),
            ],
          ),
        ),
      ),
    );
  }
}
