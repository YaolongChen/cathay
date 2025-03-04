import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../domain/aggregate/playlist_aggregate.dart';

part 'player_state.freezed.dart';

@freezed
abstract class PlayerState with _$PlayerState {
  const PlayerState._();

  const factory PlayerState({
    PlaylistAggregate? playlist,
  }) = _PlayerState;
}
