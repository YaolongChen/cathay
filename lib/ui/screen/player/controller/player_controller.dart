import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart' as just_audio;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../config/dependencies.dart';
import '../../../../domain/aggregate/playlist_aggregate.dart';
import '../../../../domain/entity/song/song.dart';
import '../state/player_state.dart';

part 'player_controller.g.dart';

@riverpod
Stream<just_audio.PlayerState> playerState(Ref ref) {
  final player = ref.read(audioPlayerProvider);
  return player.playerStateStream;
}

@riverpod
Stream<Duration?> playerPosition(Ref ref) {
  final player = ref.read(audioPlayerProvider);
  return player.positionStream;
}

@riverpod
Stream<Duration?> playerDuration(Ref ref) {
  final player = ref.read(audioPlayerProvider);
  return player.durationStream;
}

@riverpod
Stream<int?> playerCurrentIndex(Ref ref) {
  final player = ref.read(audioPlayerProvider);
  return player.currentIndexStream;
}

@Riverpod(keepAlive: true)
class PlayerController extends _$PlayerController {
  @override
  FutureOr<PlayerState> build() async {
    return const PlayerState();
  }

  Future<void> play(PlaylistAggregate playlist, SongId songId) async {
    final songs = playlist.songs;
    if (songs.isEmpty) {
      return;
    }

    final preState = await future;
    final player = ref.read(audioPlayerProvider);
    if (player.loopMode != just_audio.LoopMode.all) {
      await player.setLoopMode(just_audio.LoopMode.all);
    }

    // 同一歌单
    if (preState.playlist?.playlist.id == playlist.playlist.id) {
      final index = preState.playlist?.songs.indexWhere((e) => e.id == songId);
      final currentIndex = player.currentIndex;
      if (index != null && index != currentIndex) {
        await player.seek(null, index: index);
        await player.play();
      } else if (index != null && index == currentIndex && !player.playing) {
        await player.play();
      }
    } else {
      // 切换歌单
      final sources =
          songs.map((e) => just_audio.AudioSource.uri(e.uri)).toList();
      final initialIndex = playlist.songs.indexWhere((e) => e.id == songId);
      await player.setAudioSources(sources, initialIndex: initialIndex);
      state = await AsyncValue.guard(() async {
        return PlayerState(playlist: playlist);
      });
      await player.play();
    }
  }

  Future<void> continuePlay() {
    final player = ref.read(audioPlayerProvider);
    return player.play();
  }

  Future<void> pause() {
    final player = ref.read(audioPlayerProvider);
    return player.pause();
  }

  Future<void> playNext() async {
    final state = await future;
    final player = ref.read(audioPlayerProvider);
    final currentIndex = player.currentIndex;
    final songLength = state.playlist?.songs.length;
    if (currentIndex == null || songLength == null || songLength <= 0) {
      return;
    }
    final nextIndex = (currentIndex + 1) % songLength;
    return player.seek(null, index: nextIndex);
  }

  Future<void> playPrevious() async {
    final state = await future;
    final player = ref.read(audioPlayerProvider);
    final currentIndex = player.currentIndex;
    final songLength = state.playlist?.songs.length;
    if (currentIndex == null || songLength == null || songLength <= 0) {
      return;
    }
    final nextIndex = (currentIndex + songLength - 1) % songLength;
    return player.seek(null, index: nextIndex);
  }

  Future<void> setPosition(Duration position) {
    final player = ref.read(audioPlayerProvider);
    return player.seek(position);
  }
}
