import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/courier_models.dart';

/// A vertical, railway-styled timeline: each checkpoint is a station, the
/// segments between them are drawn as rail tracks (two rails + sleepers), and
/// the parcel sits at the current station like a train on the line.
class RailTimeline extends StatelessWidget {
  final List<TrackCheckpoint> checkpoints;
  const RailTimeline({super.key, required this.checkpoints});

  static const Color _done = Color(0xFF1F8A50);
  static const Color _pending = Color(0xFFBDBDBD);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < checkpoints.length; i++)
          _RailRow(
            cp: checkpoints[i],
            isFirst: i == 0,
            isLast: i == checkpoints.length - 1,
            doneColor: _done,
            pendingColor: _pending,
          ),
      ],
    );
  }
}

class _RailRow extends StatelessWidget {
  final TrackCheckpoint cp;
  final bool isFirst;
  final bool isLast;
  final Color doneColor;
  final Color pendingColor;

  const _RailRow({
    required this.cp,
    required this.isFirst,
    required this.isLast,
    required this.doneColor,
    required this.pendingColor,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;
    final reached = cp.done || cp.current;
    final aboveColor = reached ? doneColor : pendingColor;
    final belowColor = cp.done ? doneColor : pendingColor;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 54,
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _TrackPainter(
                      aboveColor: aboveColor,
                      belowColor: belowColor,
                      drawAbove: !isFirst,
                      drawBelow: !isLast,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: _Node(cp: cp, doneColor: doneColor, primary: primary),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 18, left: 4, top: 2),
              child: _StationInfo(cp: cp),
            ),
          ),
        ],
      ),
    );
  }
}

class _Node extends StatelessWidget {
  final TrackCheckpoint cp;
  final Color doneColor;
  final Color primary;
  const _Node({required this.cp, required this.doneColor, required this.primary});

  @override
  Widget build(BuildContext context) {
    if (cp.current) {
      return Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: primary.withValues(alpha: 0.5),
                blurRadius: 10,
                spreadRadius: 1),
          ],
        ),
        child: const Icon(Icons.train_rounded, color: Colors.white, size: 20),
      )
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .scaleXY(end: 1.12, duration: 800.ms, curve: Curves.easeInOut);
    }
    if (cp.done) {
      return Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(color: doneColor, shape: BoxShape.circle),
        child: const Icon(Icons.check_rounded, color: Colors.white, size: 18),
      );
    }
    return Container(
      width: 22,
      height: 22,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: context.colors.surface,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFBDBDBD), width: 2.5),
      ),
    );
  }
}

class _StationInfo extends StatelessWidget {
  final TrackCheckpoint cp;
  const _StationInfo({required this.cp});

  @override
  Widget build(BuildContext context) {
    final muted = !cp.done && !cp.current;
    final titleColor =
        muted ? context.colors.onSurfaceVariant : context.colors.onSurface;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          cp.station,
          style: TextStyle(
            fontWeight: cp.current ? FontWeight.w800 : FontWeight.w600,
            color: titleColor,
          ),
        ),
        Text(cp.note,
            style: TextStyle(
                fontSize: 12.5, color: context.colors.onSurfaceVariant)),
        const SizedBox(height: 2),
        Text(
          muted
              ? 'Anggaran ${Formatters.date(cp.time)} • ${Formatters.time(cp.time)}'
              : '${Formatters.date(cp.time)} • ${Formatters.time(cp.time)}',
          style: TextStyle(
            fontSize: 11.5,
            color: cp.current
                ? context.colors.primary
                : context.colors.onSurfaceVariant,
            fontWeight: cp.current ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

/// Paints the rail track (two parallel rails + sleepers) above and/or below the
/// node, colouring each half by whether the parcel has passed it.
class _TrackPainter extends CustomPainter {
  final Color aboveColor;
  final Color belowColor;
  final bool drawAbove;
  final bool drawBelow;

  _TrackPainter({
    required this.aboveColor,
    required this.belowColor,
    required this.drawAbove,
    required this.drawBelow,
  });

  static const double _nodeY = 20; // centre of the node from the top
  static const double _railGap = 4; // half-distance between the two rails
  static const double _sleeper = 7; // half-width of a sleeper tick
  static const double _sleeperStep = 11;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    if (drawAbove) {
      _paintSegment(canvas, cx, 0, _nodeY, aboveColor);
    }
    if (drawBelow) {
      _paintSegment(canvas, cx, _nodeY, size.height, belowColor);
    }
  }

  void _paintSegment(
      Canvas canvas, double cx, double top, double bottom, Color color) {
    final rail = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    final tie = Paint()
      ..color = color.withValues(alpha: 0.7)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    // Two rails.
    canvas.drawLine(Offset(cx - _railGap, top), Offset(cx - _railGap, bottom), rail);
    canvas.drawLine(Offset(cx + _railGap, top), Offset(cx + _railGap, bottom), rail);

    // Sleepers.
    for (var y = top + _sleeperStep / 2; y < bottom; y += _sleeperStep) {
      canvas.drawLine(Offset(cx - _sleeper, y), Offset(cx + _sleeper, y), tie);
    }
  }

  @override
  bool shouldRepaint(_TrackPainter old) =>
      old.aboveColor != aboveColor ||
      old.belowColor != belowColor ||
      old.drawAbove != drawAbove ||
      old.drawBelow != drawBelow;
}
