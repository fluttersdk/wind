import 'package:flutter/material.dart';

import '../parser/wind_style.dart';

/// Wraps a widget in the appropriate animation based on [WindAnimationType].
///
/// Uses Flutter's animation widgets:
/// - `spin` → [RotationTransition] with infinite rotation
/// - `ping` → Scale + Fade animation
/// - `pulse` → Opacity pulse between 0.5 and 1.0
/// - `bounce` → Vertical bounce animation
class WindAnimationWrapper extends StatefulWidget {
  final Widget child;
  final WindAnimationType animationType;
  final Duration duration;
  final Curve curve;

  const WindAnimationWrapper({
    super.key,
    required this.child,
    required this.animationType,
    this.duration = const Duration(milliseconds: 1000),
    this.curve = Curves.linear,
  });

  @override
  State<WindAnimationWrapper> createState() => _WindAnimationWrapperState();
}

class _WindAnimationWrapperState extends State<WindAnimationWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _setupAnimation();
  }

  void _setupAnimation() {
    switch (widget.animationType) {
      case WindAnimationType.spin:
        _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
        _controller.repeat();
        break;
      case WindAnimationType.ping:
        _animation = Tween<double>(
          begin: 1.0,
          end: 1.5,
        ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
        _controller.repeat();
        break;
      case WindAnimationType.pulse:
        _animation = Tween<double>(begin: 1.0, end: 0.5).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
        );
        _controller.repeat(reverse: true);
        break;
      case WindAnimationType.bounce:
        _animation = Tween<double>(begin: 0.0, end: -0.25).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
        );
        _controller.repeat(reverse: true);
        break;
      case WindAnimationType.none:
        // No animation
        break;
    }
  }

  @override
  void didUpdateWidget(WindAnimationWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animationType != widget.animationType ||
        oldWidget.duration != widget.duration) {
      _controller.stop();
      _controller.duration = widget.duration;
      _setupAnimation();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.animationType) {
      case WindAnimationType.spin:
        return RotationTransition(turns: _animation, child: widget.child);
      case WindAnimationType.ping:
        return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Opacity(
              opacity: (1.5 - _animation.value).clamp(0.0, 1.0),
              child: Transform.scale(scale: _animation.value, child: child),
            );
          },
          child: widget.child,
        );
      case WindAnimationType.pulse:
        return FadeTransition(opacity: _animation, child: widget.child);
      case WindAnimationType.bounce:
        return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _animation.value * 20),
              child: child,
            );
          },
          child: widget.child,
        );
      case WindAnimationType.none:
        return widget.child;
    }
  }
}

/// Helper function to wrap a widget with animation if animationType is set.
Widget wrapWithAnimation({
  required Widget child,
  WindAnimationType? animationType,
  Duration? duration,
  Curve? curve,
}) {
  if (animationType == null || animationType == WindAnimationType.none) {
    return child;
  }

  return WindAnimationWrapper(
    animationType: animationType,
    duration: duration ?? const Duration(milliseconds: 1000),
    curve: curve ?? Curves.linear,
    child: child,
  );
}
