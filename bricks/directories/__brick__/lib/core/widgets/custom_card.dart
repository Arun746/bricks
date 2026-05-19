import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final double height;
  final double width;
  final Widget child;
  final EdgeInsets? margin;
  final BorderRadius? borderRadius;
  final List<Color>? gradientColors;
  final List<double>? gradientStops;
  final Alignment? gradientBegin;
  final Alignment? gradientEnd;
  final Color? borderColor;

  final double borderWidth;

  const CustomCard({
    super.key,
    required this.height,
    required this.width,
    required this.child,
    this.margin,
    this.borderRadius,
    this.gradientColors,
    this.gradientStops,
    this.gradientBegin,
    this.gradientEnd,
    this.borderColor,
    this.borderWidth = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    // Default gradient colors if not provided
    final defaultGradientColors = [
      const Color(0xFFFFFFFF),
      const Color(0x50A196B4),
      const Color(0x20442D69),
    ];

    final defaultGradientStops = [0.2, 0.6, 1.0];

    return Container(
      height: height,
      width: width,
      margin: margin,
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor ?? const Color(0x49494900),
          width: borderWidth,
        ),
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: gradientColors ?? defaultGradientColors,
          stops: gradientStops ?? defaultGradientStops,
          begin: gradientBegin ?? Alignment.topLeft,
          end: gradientEnd ?? Alignment.bottomRight,
        ),
      ),
      child: child,
    );
  }
}
