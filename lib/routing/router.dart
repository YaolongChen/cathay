import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/entity/song/song.dart';
import '../ui/screen/local_songs/local_songs_screen.dart';
import '../ui/screen/playlist/playlist_view.dart';
import '../ui/screen/playlist/playlist_screen.dart';
import '../ui/screen/playlist_detail/playlist_detail_view.dart';
import 'routes.dart';

part 'router.g.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: Routes.playlist,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      return null;
    },
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return PlaylistScreen(routePath: state.uri, child: child);
        },
        routes: [
          GoRoute(
            path: Routes.playlist,
            builder: (context, state) {
              return const PlaylistView();
            },
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final id = state.pathParameters['id'];
                  return PlaylistDetailView(id: id!);
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: Routes.localSong,
        builder: (context, state) {
          return LocalSongsScreen(
            inPlaylistSongIds: state.extra as List<SongId>? ?? [],
          );
        },
      ),
    ],
  );
}
