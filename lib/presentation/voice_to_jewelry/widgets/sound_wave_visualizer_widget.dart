import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class SoundWaveVisualizerWidget extends StatefulWidget {
  final bool isRecording;
  final List<double> audioLevels;

  const SoundWaveVisualizerWidget({
    Key? key,
    required this.isRecording,
    required this.audioLevels,
  }) : super(key: key);

  @override
  State<SoundWaveVisualizerWidget> createState() =>
      _SoundWaveVisualizerWidgetState();
}

class _SoundWaveVisualizerWidgetState extends State<SoundWaveVisualizerWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
  }

  @override
  void didUpdateWidget(SoundWaveVisualizerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecording && !oldWidget.isRecording) {
      _animationController.repeat();
    } else if (!widget.isRecording && oldWidget.isRecording) {
      _animationController.stop();
      _animationController.reset();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
      height: 15.h,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: SoundWavePainter(
              audioLevels: widget.audioLevels,
              isRecording: widget.isRecording,
              animationValue: _animation.value,
              primaryColor: AppTheme.lightTheme.colorScheme.primary,
              backgroundColor: AppTheme.lightTheme.colorScheme.surface,
            ),
            size: Size(80.w, 15.h),
          );
        },
      ),
    );
  }
}

class SoundWavePainter extends CustomPainter {
  final List<double> audioLevels;
  final bool isRecording;
  final double animationValue;
  final Color primaryColor;
  final Color backgroundColor;

  SoundWavePainter({
    required this.audioLevels,
    required this.isRecording,
    required this.animationValue,
    required this.primaryColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primaryColor.withOpacity(isRecording ? 0.8 : 0.3)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final centerY = size.height / 2;
    final barWidth = size.width / 50;
    final spacing = barWidth * 0.5;

    for (int i = 0; i < 50; i++) {
      final x = i * (barWidth + spacing);
      double height;

      if (isRecording && audioLevels.isNotEmpty) {
        final levelIndex = (i * audioLevels.length / 50).floor();
        height = audioLevels[levelIndex] * size.height * 0.8;
      } else {
        // Static wave pattern when not recording
        height = (20 + (i % 5) * 10) * (isRecording ? animationValue : 0.3);
      }

      height = height.clamp(10.0, size.height * 0.8);

      canvas.drawLine(
        Offset(x, centerY - height / 2),
        Offset(x, centerY + height / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
