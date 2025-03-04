import 'package:flutter/material.dart';

import '../../../domain/entity/playlist/playlist.dart';
import 'widget/playlist_detail_app_bar.dart';
import 'widget/playlist_detail_header_view.dart';
import 'widget/playlist_detail_song_list_view.dart';

class PlaylistDetailView extends StatelessWidget {
  const PlaylistDetailView({super.key, required this.id});

  final PlaylistId id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: PlaylistDetailAppBar(id: id),
      ),
      body: Column(
        children: [
          PlaylistDetailHeaderView(id: id),
          Expanded(child: PlaylistDetailSongListView(id: id)),
        ],
      ),
    );
  }
}
