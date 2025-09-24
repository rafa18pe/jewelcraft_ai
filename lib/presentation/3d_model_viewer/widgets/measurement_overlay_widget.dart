import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MeasurementOverlayWidget extends StatelessWidget {
  final bool isVisible;
  final bool useMetric;
  final VoidCallback onToggleUnit;
  final VoidCallback onToggleVisibility;

  const MeasurementOverlayWidget({
    Key? key,
    required this.isVisible,
    required this.useMetric,
    required this.onToggleUnit,
    required this.onToggleVisibility,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isVisible) {
      return Positioned(
        top: 15.h,
        right: 4.w,
        child: GestureDetector(
          onTap: onToggleVisibility,
          child: Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface
                  .withOpacity(0.9),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: CustomIconWidget(
              iconName: 'straighten',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 20,
            ),
          ),
        ),
      );
    }

    final measurements = [
      {'label': 'Ancho', 'value': useMetric ? '15,2 mm' : '0,60 in'},
      {'label': 'Alto', 'value': useMetric ? '8,5 mm' : '0,33 in'},
      {'label': 'Profundidad', 'value': useMetric ? '3,2 mm' : '0,13 in'},
      {'label': 'Peso estimado', 'value': '2,8 g'},
    ];

    return Positioned(
      top: 15.h,
      right: 4.w,
      child: Container(
        width: 45.w,
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color:
              AppTheme.lightTheme.colorScheme.surface.withOpacity(0.95),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Medidas',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: onToggleUnit,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.primaryColor
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          useMetric ? 'mm' : 'in',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    GestureDetector(
                      onTap: onToggleVisibility,
                      child: CustomIconWidget(
                        iconName: 'close',
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 1.5.h),
            ...measurements
                .map((measurement) => Padding(
                      padding: EdgeInsets.only(bottom: 1.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            measurement['label']!,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onSurface
                                  .withOpacity(0.7),
                            ),
                          ),
                          Text(
                            measurement['value']!,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.lightTheme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }
}
