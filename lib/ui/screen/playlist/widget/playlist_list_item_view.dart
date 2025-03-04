import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/localization.dart';
import '../../../core/theme/dimens.dart';
import '../../../widget/playing_icon.dart';
import '../../player/controller/player_controller.dart';
import '../state/playlist_state.dart';

class PlaylistListItemView extends ConsumerStatefulWidget {
  const PlaylistListItemView({
    super.key,
    required this.playlist,
    required this.editing,
    required this.onTap,
    required this.onLongPress,
  });

  final UiPlaylist playlist;
  final bool editing;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  ConsumerState<PlaylistListItemView> createState() =>
      _PlaylistListItemViewState();
}

class _PlaylistListItemViewState extends ConsumerState<PlaylistListItemView> {
  late bool _coverError;

  @override
  void initState() {
    super.initState();
    _coverError = false;
  }

  void _onCoverError(Object e, StackTrace? s) {
    setState(() {
      _coverError = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final playingPlaylistId =
        ref.watch(playerControllerProvider).valueOrNull?.playlist?.playlist.id;

    final colorScheme = ColorScheme.of(context);
    final surfaceOnImage = colorScheme.surfaceContainerHighest.withAlpha(
      (255 * .54).toInt(),
    );
    const borderRadius = BorderRadius.all(Dimens.cornerMedium);
    const iconSize = Dimens.profilePictureSize / 2;
    final checked = widget.playlist.checked;
    final coverUri = widget.playlist.entity.coverUri;
    final playing = playingPlaylistId == widget.playlist.entity.id;

    // 底部歌单名
    final itemBottomText = Align(
      alignment: AlignmentDirectional.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(Dimens.padding8),
        constraints: const BoxConstraints(minWidth: double.infinity),
        decoration: BoxDecoration(
          borderRadius: borderRadius.copyWith(
            topLeft: Radius.zero,
            topRight: Radius.zero,
          ),
          color: surfaceOnImage,
        ),
        child: Text(
          widget.playlist.entity.name.value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
    );

    Widget? icon;
    if (playing && !checked) {
      icon = const PlayingIcon(size: iconSize);
    } else if (_coverError && !checked) {
      icon = Icon(
        Icons.broken_image,
        color: ColorScheme.of(context).onSecondaryContainer,
        size: iconSize,
      );
    } else if (coverUri == null && !checked) {
      icon = Icon(
        Icons.question_mark,
        color: ColorScheme.of(context).onSecondaryContainer,
        size: iconSize,
      );
    }

    final child = Material(
      type: MaterialType.card,
      elevation: 1.0,
      color: colorScheme.surfaceContainerLow,
      shape: const RoundedRectangleBorder(borderRadius: borderRadius),
      shadowColor: colorScheme.shadow,
      surfaceTintColor: Colors.transparent,
      child: Ink(
        decoration:
            coverUri == null
                ? null
                : BoxDecoration(
                  borderRadius: borderRadius,
                  image: DecorationImage(
                    image: FileImage(File.fromUri(coverUri)),
                    fit: BoxFit.cover,
                    onError: _onCoverError,
                  ),
                ),
        child: InkWell(
          onTap: widget.onTap,
          onLongPress: widget.onLongPress,
          borderRadius: borderRadius,
          child: Stack(
            children: [
              if (widget.editing)
                Container(
                  alignment: AlignmentDirectional.center,
                  decoration: BoxDecoration(
                    color: surfaceOnImage,
                    borderRadius: borderRadius,
                  ),
                  child:
                      checked
                          ? Icon(
                            Icons.check,
                            color: colorScheme.primary,
                            size: iconSize,
                          )
                          : null,
                ),
              itemBottomText,
              Center(child: icon),
            ],
          ),
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(Dimens.padding4),
      child: child,
    );
  }
}
