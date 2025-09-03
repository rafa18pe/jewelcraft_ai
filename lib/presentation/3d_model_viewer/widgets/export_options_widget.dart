import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ExportOptionsWidget extends StatelessWidget {
  final VoidCallback onExportSTL;
  final VoidCallback onExportRender;
  final VoidCallback onShareAR;

  const ExportOptionsWidget({
    Key? key,
    required this.onExportSTL,
    required this.onExportRender,
    required this.onShareAR,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildExportButton(
            iconName: 'download',
            label: 'STL',
            onTap: onExportSTL,
            color: AppTheme.lightTheme.primaryColor,
          ),
          SizedBox(width: 3.w),
          _buildExportButton(
            iconName: 'image',
            label: 'Render',
            onTap: onExportRender,
            color: AppTheme.getSuccessColor(true),
          ),
          SizedBox(width: 3.w),
          _buildExportButton(
            iconName: 'view_in_ar',
            label: 'AR',
            onTap: onShareAR,
            color: AppTheme.getAccentColor(true),
          ),
        ],
      ),
    );
  }

  Widget _buildExportButton({
    required String iconName,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: color,
              size: 20,
            ),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
