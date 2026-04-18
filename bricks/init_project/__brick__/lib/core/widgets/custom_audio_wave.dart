import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class CustomAudioWave extends StatefulWidget {
  //final List<double> amplitudeValues;
  final bool animate;
  final double barWidth;
  final double spacing;
  final double? height;
  final double? width;

  ///if true when animate is false, value's height will be adjusted
  ///to it's width
  final bool resetToZero;
  final Color? waveColor;

  const CustomAudioWave({
    Key? key,
    //required this.amplitudeValues,
    this.barWidth = 3.72,
    required this.animate,
    this.spacing = 2.72,
    this.resetToZero = false,
    this.waveColor,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  State<CustomAudioWave> createState() => _CustomAudioWaveState();
}

class _CustomAudioWaveState extends State<CustomAudioWave> {
  late List<double> amplitudeValues;
  @override
  void initState() {
    amplitudeValues = generateRandomList(20);
    super.initState();
  }

  List<double> getInterpolated(int maxBars) {
    List<double> interpolated = [];
    final factor = maxBars / (amplitudeValues.length);
    for (int i = 0; i < amplitudeValues.length - 1; i++) {
      final start = amplitudeValues[i];
      final end = amplitudeValues[i + 1];
      interpolated.add(start);
      for (int j = 1; j < factor; j++) {
        double t = j / factor;
        interpolated.add(lerpDouble(start, end, t) ?? start);
      }
      interpolated.add(end);
    }
    List<double> downsampled = [];
    double step = (interpolated.length - 1) / (maxBars - 1); // Step size

    for (int i = 0; i < maxBars; i++) {
      int index = (i * step).round(); // Select nearest index
      downsampled.add(interpolated[index]);
    }

    return downsampled;
  }

  List<double> generateRandomList(int length) {
    Random random = Random();
    return List.generate(length, (_) => random.nextDouble());
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: Center(
        child: LayoutBuilder(builder: (context, constraints) {
          final maxHeight = constraints.maxHeight;
          final availableWidth = constraints.maxWidth;

          int maxBars =
              (availableWidth / (widget.barWidth + widget.spacing)).floor();
          final interpolatedValues = getInterpolated(maxBars);

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: interpolatedValues
                .map(
                  (e) => widget.animate
                      ? RepaintBoundary(
                          child: _AnimatedBar(
                            barWidth: widget.barWidth,
                            initialHeight: e,
                            spacing: widget.spacing,
                            maxHeight: maxHeight,
                            barColor: widget.waveColor ?? Colors.white,
                          ),
                        )
                      : _Bar(
                          barWidth: widget.barWidth,
                          initialHeight:
                              widget.resetToZero ? widget.barWidth : e,
                          spacing: widget.spacing,
                          maxHeight:
                              widget.resetToZero ? widget.barWidth : maxHeight,
                          barColor: widget.waveColor ?? Colors.white,
                        ),
                )
                .toList(),
          );
        }),
      ),
    );
  }
}

class _AnimatedBar extends StatefulWidget {
  const _AnimatedBar({
    required this.initialHeight,
    required this.maxHeight,
    required this.barWidth,
    required this.spacing,
    required this.barColor,
  });

  final double initialHeight;
  final double spacing, barWidth;
  final double maxHeight;
  final Color barColor;

  @override
  State<_AnimatedBar> createState() => _BarState();
}

class _BarState extends State<_AnimatedBar> {
  Timer? timer;
  double height = 0;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animate();
    });
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
    timer?.cancel();
  }

  _animate() {
    timer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      setState(() {
        height = Random().nextDouble();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: (height * widget.maxHeight).clamp(2.0, widget.maxHeight),
      duration: const Duration(milliseconds: 350),
      width: widget.barWidth,
      margin: EdgeInsets.symmetric(horizontal: widget.spacing / 2),
      decoration: BoxDecoration(
        color: widget.barColor,
        borderRadius: BorderRadius.circular(widget.barWidth / 2),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final double initialHeight;
  final double spacing, barWidth;
  final double maxHeight;
  final Color barColor;
  const _Bar({
    required this.spacing,
    required this.barWidth,
    required this.initialHeight,
    required this.maxHeight,
    required this.barColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (initialHeight * maxHeight).clamp(2.0, maxHeight),
      width: barWidth,
      margin: EdgeInsets.symmetric(horizontal: spacing / 2),
      decoration: BoxDecoration(
        color: barColor,
        borderRadius: BorderRadius.circular(barWidth / 2),
      ),
    );
  }
}
