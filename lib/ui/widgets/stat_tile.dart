import 'package:flutter/material.dart';

class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.title,
    required this.valueText,
    required this.icon,
  });

  final String title;
  final String valueText;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final labelColor = colorScheme.onSurface.withOpacity(0.7);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: labelColor),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const SizedBox(width: 6),
            Text(
              valueText,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
          ],
        ),
      ],
    );
  }
}

class StatIcon extends StatelessWidget {
  const StatIcon({
    super.key,
    required this.icon,
    required this.active,
    required this.gradientColors,
  });

  final IconData icon;
  final bool active;
  final List<Color> gradientColors;

  @override
  Widget build(BuildContext context) {
    const iconSize = 20.0;
    final gradient = LinearGradient(
      colors: gradientColors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    final iconWidget = ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(bounds),
      blendMode: BlendMode.srcIn,
      child: Icon(icon, size: iconSize, color: Colors.white),
    );

    if (!active) {
      return iconWidget;
    }

    final glowBase = Color.lerp(
          gradientColors.first,
          gradientColors.last,
          0.5,
        ) ??
        gradientColors.first;
    final glowColor = glowBase.withOpacity(0.16);

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: glowColor,
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
        iconWidget,
      ],
    );
  }
}
