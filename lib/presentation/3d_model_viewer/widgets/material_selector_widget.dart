import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MaterialSelectorWidget extends StatelessWidget {
  final String selectedMaterial;
  final Function(String) onMaterialChanged;

  const MaterialSelectorWidget({
    Key? key,
    required this.selectedMaterial,
    required this.onMaterialChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final materials = [
      {'name': 'Oro 14k', 'color': const Color(0xFFDAA520), 'id': 'gold_14k'},
      {'name': 'Oro 18k', 'color': const Color(0xFFFFD700), 'id': 'gold_18k'},
      {
        'name': 'Plata 925',
        'color': const Color(0xFFC0C0C0),
        'id': 'silver_925'
      },
      {'name': 'Platino', 'color': const Color(0xFFE5E4E2), 'id': 'platinum'},
    ];

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Material',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: materials.map((material) {
              final isSelected = selectedMaterial == material['id'];
              return Padding(
                padding: EdgeInsets.only(right: 2.w),
                child: GestureDetector(
                  onTap: () => onMaterialChanged(material['id'] as String),
                  child: Container(
                    width: 12.w,
                    height: 6.h,
                    decoration: BoxDecoration(
                      color: material['color'] as Color,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.lightTheme.primaryColor
                            : Colors.grey.withValues(alpha: 0.3),
                        width: isSelected ? 3 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppTheme.lightTheme.primaryColor
                                    .withValues(alpha: 0.3),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                    child: isSelected
                        ? Center(
                            child: CustomIconWidget(
                              iconName: 'check',
                              color: Colors.white,
                              size: 16,
                            ),
                          )
                        : null,
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 1.h),
          Text(
            materials.firstWhere((m) => m['id'] == selectedMaterial)['name']
                as String,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
