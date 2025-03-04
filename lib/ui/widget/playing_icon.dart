import 'dart:math';

import 'package:flutter/material.dart';

class PlayingIcon extends StatefulWidget {
  const PlayingIcon({super.key, required this.size});

  final double size;

  @override
  State<PlayingIcon> createState() => _PlayingIconState();
}

class _PlayingIconState extends State<PlayingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.addListener(() {
      setState(() {});
    });
    _controller.repeat(reverse: false, period: Durations.extralong2);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      willChange: true,
      size: Size.square(widget.size),
      painter: _PlayingIconPainter(
        value: _controller.value,
        color: ColorScheme.of(context).primary,
      ),
    );
  }
}

class _PlayingIconPainter extends CustomPainter {
  const _PlayingIconPainter({
    super.repaint,
    required this.value,
    required this.color,
  });

  final Color color;
  final double value;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.shortestSide / 20.0;
    final strokeWidth = 3 * scale;
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = strokeWidth;

    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width,
      height: size.height,
    );

    canvas.drawLine(
      rect.bottomLeft + Offset(strokeWidth / 2, 0),
      rect.bottomLeft +
          Offset(
            strokeWidth / 2,
            -rect.height * (.5 + .5 * sin(value * 2 * pi)),
          ),
      paint,
    );

    canvas.drawLine(
      rect.bottomCenter,
      rect.bottomCenter +
          Offset(0, -rect.height * (.5 + .5 * sin(value * 2 * pi + pi / 2))),
      paint,
    );

    canvas.drawLine(
      rect.bottomRight + Offset(-strokeWidth / 2, 0),
      rect.bottomRight +
          Offset(
            -strokeWidth / 2,
            -rect.height * (.5 + .5 * sin(value * 2 * pi + pi)),
          ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _PlayingIconPainter oldDelegate) {
    return oldDelegate.value != value || oldDelegate.color != color;
  }
}
