import 'package:content_uri_image/content_uri_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../domain/entity/playlist/playlist.dart';
import '../../../../domain/entity/song/song.dart';
import '../../../../routing/routes.dart';
import '../../../core/localization/localization.dart';
import '../../../core/theme/dimens.dart';
import '../../../widget/loading_error_view.dart';
import '../../../widget/loading_view.dart';
import '../../../widget/playing_icon.dart';
import '../../player/controller/player_controller.dart';
import '../controller/playlist_detail_controller.dart';

class PlaylistDetailSongListView extends ConsumerWidget {
  const PlaylistDetailSongListView({super.key, required this.id});

  final PlaylistId id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(playlistDetailControllerProvider(id));
    final playingPlaylist = ref.watch(playerControllerProvider).valueOrNull;
    final playingSongIndex = ref.watch(playerCurrentIndexProvider).valueOrNull;
    final playingSongId =
        playingSongIndex != null
            ? playingPlaylist?.playlist?.songs[playingSongIndex].id
            : null;

    return state.when(
      skipError: true,
      data: (data) {
        final songs = data.songs;

        if (songs.isEmpty) {
          return _PlaylistDetailSongListEmptyView(
            onTapSelectSongsButton: () async {
              final songs = await context.push<List<Song>>(Routes.localSong);
              if (songs != null) {
                ref
                    .read(playlistDetailControllerProvider(id).notifier)
                    .addSong(songs);
              }
            },
          );
        }

        return ListView.builder(
          prototypeItem: const ListTile(
            isThreeLine: false,
            leading: SizedBox.square(dimension: 40),
            title: Text('title', maxLines: 1),
            subtitle: Text('title', maxLines: 1),
            trailing: Text('trailing'),
          ),
          itemBuilder: (context, index) {
            final song = songs[index];
            final isPlaying = song.id == playingSongId;
            final totalSeconds = song.duration.inSeconds;
            final minutes = (totalSeconds ~/ Duration.secondsPerMinute)
                .toString()
                .padLeft(2, '0');
            final seconds = (totalSeconds % Duration.secondsPerMinute)
                .toString()
                .padLeft(2, '0');

            return Dismissible(
              key: ValueKey(song.id),
              onDismissed: (direction) {
                ref
                    .read(playlistDetailControllerProvider(id).notifier)
                    .removeSongFromPlaylist(song.id);
              },
              child: ListTile(
                onTap: () {
                  ref
                      .read(playerControllerProvider.notifier)
                      .play(data, song.id);
                },
                leading:
                    isPlaying
                        ? Container(
                          padding: const EdgeInsets.all(Dimens.padding2),
                          child: const PlayingIcon(size: 20),
                        )
                        : SizedBox(
                          width: 24,
                          height: 24,
                          child: Image(
                            image: ContentUriImageProvider(song.albumUri),
                            fit: BoxFit.cover,
                            errorBuilder: (context, e, s) {
                              return Icon(
                                Icons.broken_image,
                                color: ColorScheme.of(context).error,
                              );
                            },
                          ),
                        ),
                isThreeLine: false,
                title: Text(
                  song.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(song.artist, maxLines: 1),
                trailing: Text('$minutes:$seconds'),
              ),
            );
          },
          itemCount: songs.length,
        );
      },
      error: (error, stackTrack) {
        return LoadingErrorView(
          onReloadTap:
              ref.read(playlistDetailControllerProvider(id).notifier).reload,
        );
      },
      loading: () {
        return const LoadingView();
      },
    );
  }
}

class _PlaylistDetailSongListEmptyView extends StatelessWidget {
  const _PlaylistDetailSongListEmptyView({
    required this.onTapSelectSongsButton,
  });

  final VoidCallback onTapSelectSongsButton;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimens.edgeInsetsScreenHorizontal,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: Dimens.spacingSmall,
        children: [
          Text(
            AppLocalization.of(context).playlistDetailSongListEmptyTip,
            textAlign: TextAlign.center,
          ),
          ElevatedButton.icon(
            onPressed: onTapSelectSongsButton,
            icon: const Icon(Icons.add),
            label: Text(
              AppLocalization.of(
                context,
              ).playlistDetailSongListEmptySelectSongButtonText,
            ),
          ),
        ],
      ),
    );
  }
}
