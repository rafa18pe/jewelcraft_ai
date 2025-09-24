import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ModelControlsWidget extends StatelessWidget {
  final VoidCallback onResetView;
  final VoidCallback onToggleWireframe;
  final VoidCallback onToggleAnimation;
  final VoidCallback onTakeScreenshot;
  final bool isWireframe;
  final bool isAnimating;

  const ModelControlsWidget({
    Key? key,
    required this.onResetView,
    required this.onToggleWireframe,
    required this.onToggleAnimation,
    required this.onTakeScreenshot,
    required this.isWireframe,
    required this.isAnimating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildControlButton(
            iconName: 'refresh',
            onTap: onResetView,
            tooltip: 'Restablecer vista',
          ),
          SizedBox(width: 3.w),
          _buildControlButton(
            iconName: isWireframe ? 'grid_on' : 'grid_off',
            onTap: onToggleWireframe,
            tooltip: isWireframe ? 'Vista sólida' : 'Vista alambre',
            isActive: isWireframe,
          ),
          SizedBox(width: 3.w),
          _buildControlButton(
            iconName: isAnimating ? 'pause' : 'play_arrow',
            onTap: onToggleAnimation,
            tooltip: isAnimating ? 'Pausar animación' : 'Reproducir animación',
            isActive: isAnimating,
          ),
          SizedBox(width: 3.w),
          _buildControlButton(
            iconName: 'camera_alt',
            onTap: onTakeScreenshot,
            tooltip: 'Capturar pantalla',
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required String iconName,
    required VoidCallback onTap,
    required String tooltip,
    bool isActive = false,
  }) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 12.w,
          height: 6.h,
          decoration: BoxDecoration(
            color: isActive
                ? AppTheme.lightTheme.primaryColor.withOpacity(0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isActive
                  ? AppTheme.lightTheme.primaryColor
                  : Colors.transparent,
              width: 1,
            ),
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: iconName,
              color: isActive
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
