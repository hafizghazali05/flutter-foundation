import 'package:flutter/material.dart';

/// Demonstrates Flutter's built-in [AnimatedIcon]. Tap to morph between the two
/// states (e.g. menu -> close, play -> pause).
class AnimatedToggleIcon extends StatefulWidget {
  final AnimatedIconData icon;
  final String label;
  final ValueChanged<bool>? onChanged;

  const AnimatedToggleIcon({
    super.key,
    required this.icon,
    required this.label,
    this.onChanged,
  });

  @override
  State<AnimatedToggleIcon> createState() => _AnimatedToggleIconState();
}

class _AnimatedToggleIconState extends State<AnimatedToggleIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  );
  bool _on = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _on = !_on);
    _on ? _controller.forward() : _controller.reverse();
    widget.onChanged?.call(_on);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton.filledTonal(
          iconSize: 28,
          onPressed: _toggle,
          icon: AnimatedIcon(icon: widget.icon, progress: _controller),
        ),
        const SizedBox(height: 6),
        Text(
          widget.label,
          style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
        ),
      ],
    );
  }
}
