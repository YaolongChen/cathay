import 'package:content_uri_image/content_uri_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/dependencies.dart';
import '../../../data/repository/sys_permission_repository.dart';
import '../../../domain/entity/song/song.dart';
import '../../core/localization/localization.dart';
import '../../core/theme/dimens.dart';
import '../../widget/loading_error_view.dart';
import '../../widget/loading_view.dart';
import 'controller/local_songs_controller.dart';

class LocalSongsScreen extends ConsumerWidget {
  const LocalSongsScreen({super.key, required this.inPlaylistSongIds});

  final List<SongId> inPlaylistSongIds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(localSongsControllerProvider);
    final appSettingsRepository = ref.read(appSettingsRepositoryProvider);
    final localization = AppLocalization.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.localSongsTitle),
        actions: [
          IconButton(
            onPressed: state.when(
              data:
                  (data) =>
                      data.selectedSongIds.isNotEmpty
                          ? () {
                            context.pop(data.selectedSongs);
                          }
                          : null,
              error: (error, stackTrace) => null,
              loading: () => null,
            ),
            tooltip: AppLocalization.of(context).check,
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: state.when(
        skipError: true,
        data: (data) {
          final songs = data.songs;

          return ListView.builder(
            itemCount: songs.length,
            prototypeItem: const ListTile(
              isThreeLine: false,
              title: Text('111', maxLines: 1),
              subtitle: Text('111', maxLines: 1),
              trailing: Text('111'),
            ),
            itemBuilder: (context, index) {
              final song = songs[index];
              final inPlaylist = inPlaylistSongIds.contains(song.id);
              final selected = data.selectedSongIds.contains(song.id);

              return CheckboxListTile(
                key: ValueKey(song),
                value: inPlaylist ? true : selected,
                isThreeLine: false,
                title: Text(song.name, maxLines: 1),
                subtitle: Text(song.artist, maxLines: 1),
                // secondary: const SizedBox(),
                secondary: SizedBox(
                  width: 40,
                  height: 40,
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
                onChanged:
                    inPlaylist
                        ? null
                        : (selected) {
                          if (selected == null) {
                            return;
                          }
                          ref
                              .read(localSongsControllerProvider.notifier)
                              .toggleItem(song);
                        },
              );
            },
          );
        },
        error: (error, stackTrace) {
          String? errorTip;
          String? reloadButtonText;
          if (error is PermissionDeniedException) {
            errorTip = localization.localSongsStorageAudioPermissionDeniedTip;
            reloadButtonText =
                localization
                    .localSongsStorageAudioPermissionDeniedRequestButtonText;
          } else if (error is PermissionPermanentlyDeniedException) {
            errorTip =
                localization
                    .localSongsStorageAudioPermissionPermanentlyDeniedTip;
            reloadButtonText =
                localization
                    .localSongsStorageAudioPermissionPermanentlyDeniedRequestButtonText;
          }

          return Padding(
            padding: Dimens.edgeInsetsScreenHorizontal,
            child: LoadingErrorView(
              tip: errorTip,
              reloadButtonText: reloadButtonText,
              onReloadTap: () async {
                if (error is PermissionPermanentlyDeniedException) {
                  await appSettingsRepository.toAppSettings();
                }
                ref.invalidate(localSongsControllerProvider);
              },
            ),
          );
        },
        loading: () {
          return const LoadingView();
        },
      ),
    );
  }
}
