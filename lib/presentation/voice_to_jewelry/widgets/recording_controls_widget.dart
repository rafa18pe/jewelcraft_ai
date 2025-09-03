import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecordingControlsWidget extends StatelessWidget {
  final bool isRecording;
  final bool hasRecording;
  final bool isPlaying;
  final VoidCallback? onPlayPause;
  final VoidCallback? onClear;

  const RecordingControlsWidget({
    Key? key,
    required this.isRecording,
    required this.hasRecording,
    required this.isPlaying,
    this.onPlayPause,
    this.onClear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!hasRecording || isRecording) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(
            icon: isPlaying ? 'pause' : 'play_arrow',
            label: isPlaying ? 'Pausar' : 'Reproducir',
            onTap: onPlayPause,
            isPrimary: true,
          ),
          _buildControlButton(
            icon: 'delete',
            label: 'Borrar',
            onTap: onClear,
            isPrimary: false,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required String icon,
    required String label,
    required VoidCallback? onTap,
    required bool isPrimary,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          color: isPrimary
              ? AppTheme.lightTheme.colorScheme.primary
              : AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(25),
          border: isPrimary
              ? null
              : Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  width: 1,
                ),
          boxShadow: [
            BoxShadow(
              color:
                  AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: isPrimary
                  ? AppTheme.lightTheme.colorScheme.onPrimary
                  : AppTheme.lightTheme.colorScheme.onSurface,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: isPrimary
                    ? AppTheme.lightTheme.colorScheme.onPrimary
                    : AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
