import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AdvancedSettingsWidget extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onToggle;
  final bool supportStructures;
  final Function(bool) onSupportStructuresChanged;
  final String printOrientation;
  final Function(String) onPrintOrientationChanged;
  final double scalingFactor;
  final Function(double) onScalingFactorChanged;

  const AdvancedSettingsWidget({
    Key? key,
    required this.isExpanded,
    required this.onToggle,
    required this.supportStructures,
    required this.onSupportStructuresChanged,
    required this.printOrientation,
    required this.onPrintOrientationChanged,
    required this.scalingFactor,
    required this.onScalingFactorChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'settings',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 6.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'Configuración Avanzada',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  CustomIconWidget(
                    iconName: isExpanded ? 'expand_less' : 'expand_more',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 6.w,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            Divider(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withOpacity(0.3),
              height: 1,
            ),
            Container(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  _buildSupportStructuresOption(context),
                  SizedBox(height: 3.h),
                  _buildPrintOrientationOption(context),
                  SizedBox(height: 3.h),
                  _buildScalingOption(context),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSupportStructuresOption(BuildContext context) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: 'support',
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 5.w,
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Estructuras de Soporte',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                'Añadir soportes automáticos',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
        Switch(
          value: supportStructures,
          onChanged: onSupportStructuresChanged,
        ),
      ],
    );
  }

  Widget _buildPrintOrientationOption(BuildContext context) {
    final orientations = [
      {'value': 'auto', 'label': 'Automática'},
      {'value': 'vertical', 'label': 'Vertical'},
      {'value': 'horizontal', 'label': 'Horizontal'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'rotate_90_degrees_ccw',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 5.w,
            ),
            SizedBox(width: 3.w),
            Text(
              'Orientación de Impresión',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          children: orientations.map((orientation) {
            final isSelected = printOrientation == orientation['value'];
            return FilterChip(
              label: Text(orientation['label'] as String),
              selected: isSelected,
              onSelected: (_) =>
                  onPrintOrientationChanged(orientation['value'] as String),
              selectedColor:
                  AppTheme.lightTheme.primaryColor.withOpacity(0.2),
              checkmarkColor: AppTheme.lightTheme.primaryColor,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildScalingOption(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'zoom_in',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 5.w,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                'Factor de Escala',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            Text(
              '${(scalingFactor * 100).toInt()}%',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Slider(
          value: scalingFactor,
          min: 0.5,
          max: 2.0,
          divisions: 15,
          onChanged: onScalingFactorChanged,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '50%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
            ),
            Text(
              '200%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}
