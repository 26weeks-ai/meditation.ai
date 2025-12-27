import 'package:flutter/material.dart';

class BreathOrb extends StatefulWidget {
  const BreathOrb({
    super.key,
    this.size = 120,
    this.intensity = 1.0,
    this.duration = const Duration(seconds: 6),
    this.minScale = 0.85,
    this.maxScale = 1.05,
    this.curve = Curves.easeInOutSine,
    this.ringLag = const Duration(milliseconds: 100),
  });

  final double size;
  final double intensity;
  final Duration duration;
  final double minScale;
  final double maxScale;
  final Curve curve;
  final Duration ringLag;

  @override
  State<BreathOrb> createState() => _BreathOrbState();
}

class _BreathOrbState extends State<BreathOrb>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _coreScale;
  late Animation<double> _ringScale;
  bool _animationsDisabled = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _configureAnimations();
    _controller.repeat(reverse: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateAnimationPlayback();
  }

  @override
  void didUpdateWidget(covariant BreathOrb oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
    }
    if (oldWidget.minScale != widget.minScale ||
        oldWidget.maxScale != widget.maxScale ||
        oldWidget.curve != widget.curve ||
        oldWidget.ringLag != widget.ringLag) {
      _configureAnimations();
    }
    _updateAnimationPlayback();
  }

  void _updateAnimationPlayback() {
    final bool disableAnimations = MediaQuery.of(context).disableAnimations;
    if (disableAnimations == _animationsDisabled) {
      return;
    }
    _animationsDisabled = disableAnimations;
    if (disableAnimations) {
      _controller.stop();
    } else {
      _controller.repeat(reverse: true);
    }
  }

  void _configureAnimations() {
    final Animation<double> base = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
      reverseCurve: widget.curve,
    );
    _coreScale = Tween<double>(
      begin: widget.minScale,
      end: widget.maxScale,
    ).animate(base);

    final double lagFraction = _lagFraction(widget.ringLag, widget.duration);
    final Curve ringCurve = Interval(
      lagFraction,
      1.0,
      curve: widget.curve,
    );
    final Curve ringReverseCurve = Interval(
      0.0,
      1.0 - lagFraction,
      curve: widget.curve,
    );
    final Animation<double> ringBase = CurvedAnimation(
      parent: _controller,
      curve: ringCurve,
      reverseCurve: ringReverseCurve,
    );
    _ringScale = Tween<double>(
      begin: widget.minScale,
      end: widget.maxScale,
    ).animate(ringBase);
  }

  double _lagFraction(Duration lag, Duration duration) {
    if (duration.inMilliseconds <= 0) {
      return 0.0;
    }
    final double fraction = lag.inMilliseconds / duration.inMilliseconds;
    return fraction.clamp(0.0, 0.1).toDouble();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool disableAnimations = MediaQuery.of(context).disableAnimations;
    final double midScale = (widget.minScale + widget.maxScale) / 2;
    final Animation<double> coreScale = disableAnimations
        ? AlwaysStoppedAnimation<double>(midScale)
        : _coreScale;
    final Animation<double> ringScale = disableAnimations
        ? AlwaysStoppedAnimation<double>(midScale)
        : _ringScale;

    return RepaintBoundary(
      child: CustomPaint(
        size: Size.square(widget.size),
        painter: _BreathOrbPainter(
          coreScale: coreScale,
          ringScale: ringScale,
          intensity: widget.intensity,
          colorScheme: Theme.of(context).colorScheme,
        ),
      ),
    );
  }
}

class _BreathOrbPainter extends CustomPainter {
  _BreathOrbPainter({
    required this.coreScale,
    required this.ringScale,
    required this.intensity,
    required this.colorScheme,
  }) : super(repaint: Listenable.merge([coreScale, ringScale]));

  final Animation<double> coreScale;
  final Animation<double> ringScale;
  final double intensity;
  final ColorScheme colorScheme;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final double baseRadius = size.shortestSide / 2;
    final double coreRadius = baseRadius * coreScale.value;
    final double ringRadius = baseRadius * ringScale.value;
    final double clampedIntensity = intensity.clamp(0.0, 1.5).toDouble();

    const double haloOpacityBase = 0.06; // Intentionally subtle.
    const double ringOpacity = 0.08; // Intentionally subtle.
    final double haloOpacity =
        (haloOpacityBase * clampedIntensity).clamp(0.0, 0.08).toDouble();

    final Color coreBase = colorScheme.surfaceContainerHighest;
    final Color coreCenter =
        Color.lerp(coreBase, colorScheme.onSurface, 0.04)!;
    final Color coreEdge = Color.lerp(coreBase, colorScheme.surface, 0.35)!;

    final double haloRadius = ringRadius * 1.6;
    final Paint haloPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          colorScheme.onSurface.withValues(alpha: haloOpacity),
          colorScheme.onSurface.withValues(alpha: haloOpacity * 0.35),
          colorScheme.onSurface.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: haloRadius));
    canvas.drawCircle(center, haloRadius, haloPaint);

    final Paint corePaint = Paint()
      ..shader = RadialGradient(
        colors: [coreCenter, coreBase, coreEdge],
        stops: const [0.0, 0.65, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: coreRadius));
    canvas.drawCircle(center, coreRadius, corePaint);

    final Paint ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1
      ..color = colorScheme.onSurface.withValues(alpha: ringOpacity);
    canvas.drawCircle(center, ringRadius, ringPaint);
  }

  @override
  bool shouldRepaint(covariant _BreathOrbPainter oldDelegate) {
    return oldDelegate.coreScale != coreScale ||
        oldDelegate.ringScale != ringScale ||
        oldDelegate.intensity != intensity ||
        oldDelegate.colorScheme != colorScheme;
  }
}
