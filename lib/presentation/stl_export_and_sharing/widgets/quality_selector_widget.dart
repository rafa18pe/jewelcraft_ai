import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QualitySelectorWidget extends StatelessWidget {
  final String selectedQuality;
  final Function(String) onQualityChanged;

  const QualitySelectorWidget({
    Key? key,
    required this.selectedQuality,
    required this.onQualityChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final qualityOptions = [
      {
        'value': 'draft',
        'title': 'Borrador',
        'subtitle': 'Rápido, menor calidad',
        'icon': 'speed',
      },
      {
        'value': 'standard',
        'title': 'Estándar',
        'subtitle': 'Equilibrado',
        'icon': 'balance',
      },
      {
        'value': 'high',
        'title': 'Alta',
        'subtitle': 'Detallado, más lento',
        'icon': 'high_quality',
      },
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Calidad de Exportación',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 2.h),
          ...qualityOptions
              .map((option) => _buildQualityOption(
                    context,
                    option['value'] as String,
                    option['title'] as String,
                    option['subtitle'] as String,
                    option['icon'] as String,
                  ))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildQualityOption(
    BuildContext context,
    String value,
    String title,
    String subtitle,
    String iconName,
  ) {
    final isSelected = selectedQuality == value;

    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: InkWell(
        onTap: () => onQualityChanged(value),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.lightTheme.primaryColor
                      : AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: CustomIconWidget(
                  iconName: iconName,
                  color: isSelected
                      ? Colors.white
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 4.w,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? AppTheme.lightTheme.primaryColor
                                : AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                CustomIconWidget(
                  iconName: 'check_circle',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 5.w,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
