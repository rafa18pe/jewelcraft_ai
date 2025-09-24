import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecordingTimerWidget extends StatelessWidget {
  final Duration recordingDuration;
  final Duration maxDuration;
  final bool isRecording;

  const RecordingTimerWidget({
    Key? key,
    required this.recordingDuration,
    required this.maxDuration,
    required this.isRecording,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isRecording && recordingDuration.inSeconds == 0) {
      return const SizedBox.shrink();
    }

    final progress =
        recordingDuration.inMilliseconds / maxDuration.inMilliseconds;
    final remainingSeconds =
        maxDuration.inSeconds - recordingDuration.inSeconds;
    final isNearLimit = remainingSeconds <= 10;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        children: [
          // Progress bar
          Container(
            width: 60.w,
            height: 6,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withOpacity(0.3),
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: isNearLimit
                      ? AppTheme.lightTheme.colorScheme.error
                      : AppTheme.lightTheme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
          SizedBox(height: 1.h),
          // Timer display
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'timer',
                color: isNearLimit
                    ? AppTheme.lightTheme.colorScheme.error
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 16,
              ),
              SizedBox(width: 1.w),
              Text(
                _formatDuration(recordingDuration),
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: isNearLimit
                      ? AppTheme.lightTheme.colorScheme.error
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                ' / ${_formatDuration(maxDuration)}',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                      .withOpacity(0.7),
                ),
              ),
            ],
          ),
          if (isNearLimit) ...[
            SizedBox(height: 0.5.h),
            Text(
              'Tiempo restante: ${remainingSeconds}s',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
