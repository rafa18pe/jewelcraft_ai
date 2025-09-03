import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ExportOptionsCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String iconName;
  final VoidCallback onTap;
  final bool isEnabled;

  const ExportOptionsCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.iconName,
    required this.onTap,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: isEnabled ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(4.w),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: isEnabled
                      ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
                      : Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: iconName,
                  color: isEnabled
                      ? AppTheme.lightTheme.primaryColor
                      : Colors.grey,
                  size: 6.w,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: isEnabled
                                ? AppTheme.lightTheme.colorScheme.onSurface
                                : Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isEnabled
                                ? AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant
                                : Colors.grey,
                          ),
                    ),
                  ],
                ),
              ),
              CustomIconWidget(
                iconName: 'chevron_right',
                color: isEnabled
                    ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    : Colors.grey,
                size: 5.w,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
