import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/dimens.dart';
import '../controller/player_controller.dart';

const _millisecondsPerFrame = 16;

class BottomPlayerBar extends ConsumerStatefulWidget {
  const BottomPlayerBar({super.key});

  @override
  ConsumerState createState() => _BottomPlayerBarState();
}

class _BottomPlayerBarState extends ConsumerState<BottomPlayerBar> {
  final _indicatorOffset = ValueNotifier<double>(.0);
  OverlayEntry? _overlayEntry;
  double _dx = .0;
  double _dxVelocity = .0;
  int _time = 0;

  void _showIndicatorOverlay() {
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return ValueListenableBuilder(
          valueListenable: _indicatorOffset,
          builder: (context, dx, child) {
            final theme = Theme.of(context);

            return Material(
              type: MaterialType.transparency,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Consumer(
                      builder: (context, ref, child) {
                        final duration =
                            ref.watch(playerDurationProvider).valueOrNull;

                        if (duration == null) {
                          return const SizedBox();
                        }

                        final screenWidth = MediaQuery.sizeOf(context).width;
                        final percent = (dx / screenWidth).clamp(0, 1);
                        final position = Duration(
                          milliseconds:
                              (percent * duration.inMilliseconds).toInt(),
                        );
                        final text =
                            '${(position.inSeconds ~/ 60).toString().padLeft(2, '0')}:${(position.inSeconds % 60).toString().padLeft(2, '0')}/${(duration.inSeconds ~/ 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';

                        return Container(
                          alignment: Alignment.center,
                          child: Text(
                            text,
                            style: theme.textTheme.displayMedium,
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    left: dx,
                    bottom: 0,
                    child: SizedBox(
                      height: kBottomNavigationBarHeight + 40,
                      child: VerticalDivider(
                        color: theme.colorScheme.primary,
                        width: 4,
                        thickness: 4,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideIndicatorOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _indicatorOffset.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playerController = ref.read(playerControllerProvider.notifier);

    final state = ref.watch(playerControllerProvider).valueOrNull;
    final currentIndex = ref.watch(playerCurrentIndexProvider).valueOrNull;
    final currentSong =
        currentIndex != null
            ? state?.playlist?.songs.elementAtOrNull(currentIndex)
            : null;

    if (currentSong == null) {
      return const SizedBox();
    }

    final durationInMilliseconds =
        ref.watch(playerDurationProvider).valueOrNull?.inMilliseconds;
    final currentPositionInMilliseconds =
        ref.watch(playerPositionProvider).valueOrNull?.inMilliseconds;
    final percent = switch ((
      currentPositionInMilliseconds,
      durationInMilliseconds,
    )) {
      (final position, final duration)
          when position != null && duration != null =>
        (position / duration).clamp(0, 1).toDouble(),
      (_, _) => .0,
    };

    final colorScheme = ColorScheme.of(context);

    return GestureDetector(
      onLongPressStart: (details) {
        _indicatorOffset.value = details.globalPosition.dx;
        _dx = details.globalPosition.dx;
        _time = DateTime.now().millisecondsSinceEpoch;

        HapticFeedback.vibrate();

        _showIndicatorOverlay();
      },
      onLongPressMoveUpdate: (details) {
        final preDx = _dx;
        final preTime = _time;
        final dx = details.globalPosition.dx;
        final time = DateTime.now().millisecondsSinceEpoch;
        final dxDelta = dx - preDx;
        final timeDelta = time - preTime;
        if (dxDelta.abs() < .5 || timeDelta < _millisecondsPerFrame) {
          return;
        }
        _dx = dx;
        _time = time;
        _dxVelocity = dxDelta / timeDelta;
        _indicatorOffset.value =
            (_indicatorOffset.value + _dxVelocity * timeDelta * 1.67);
      },
      onLongPressEnd: (details) {
        if (durationInMilliseconds != null) {
          final position =
              durationInMilliseconds *
              (_indicatorOffset.value / MediaQuery.sizeOf(context).width);
          playerController.setPosition(
            Duration(milliseconds: position.toInt()),
          );
        }
        _hideIndicatorOverlay();
      },
      onLongPressCancel: () {
        _hideIndicatorOverlay();
      },
      child: CustomPaint(
        painter: _BottomPlayerBarBackgroundPainter(
          percent: percent,
          activeColor: colorScheme.primaryFixedDim,
          inactiveColor: colorScheme.primaryContainer,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: Dimens.paddingScreenHorizontal,
            right: Dimens.paddingScreenHorizontal,
            top: Dimens.padding8,
            bottom: Dimens.padding8,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentSong.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: Dimens.padding4),
                    Text(
                      currentSong.artist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => playerController.playPrevious(),
                icon: const Icon(Icons.navigate_before),
              ),
              Consumer(
                builder: (context, ref, child) {
                  final playState = ref.watch(playerStateProvider);

                  return switch (playState.value?.playing) {
                    null => const SizedBox(),
                    true => IconButton(
                      onPressed: () => playerController.pause(),
                      icon: const Icon(Icons.pause),
                    ),
                    false => IconButton(
                      onPressed: () => playerController.continuePlay(),
                      icon: const Icon(Icons.play_arrow),
                    ),
                  };
                },
              ),
              IconButton(
                onPressed: () => playerController.playNext(),
                icon: const Icon(Icons.navigate_next),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomPlayerBarBackgroundPainter extends CustomPainter {
  _BottomPlayerBarBackgroundPainter({
    required this.percent,
    required this.activeColor,
    required this.inactiveColor,
  }) : assert(0 <= percent && percent <= 1);

  final double percent;
  final Color activeColor;
  final Color inactiveColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..style = PaintingStyle.fill
          ..color = activeColor;

    canvas.drawRect(
      Rect.fromLTRB(0, 0, size.width * percent, size.height),
      paint,
    );

    paint.color = inactiveColor;

    canvas.drawRect(
      Rect.fromLTRB(size.width * percent, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(_BottomPlayerBarBackgroundPainter oldDelegate) {
    return oldDelegate.activeColor != activeColor ||
        oldDelegate.inactiveColor != inactiveColor ||
        oldDelegate.percent != percent;
  }
}
