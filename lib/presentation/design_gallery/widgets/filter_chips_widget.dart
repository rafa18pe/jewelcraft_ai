import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class FilterChipsWidget extends StatelessWidget {
  final List<String> filters;
  final String selectedFilter;
  final Function(String) onFilterSelected;

  const FilterChipsWidget({
    Key? key,
    required this.filters,
    required this.selectedFilter,
    required this.onFilterSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 6.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: filters.length,
        separatorBuilder: (context, index) => SizedBox(width: 2.w),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = filter == selectedFilter;

          return FilterChip(
            label: Text(
              filter,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: isSelected
                        ? (isDarkMode
                            ? AppTheme.onPrimaryDark
                            : AppTheme.onPrimaryLight)
                        : (isDarkMode
                            ? AppTheme.textPrimaryDark
                            : AppTheme.textPrimaryLight),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
            ),
            selected: isSelected,
            onSelected: (selected) => onFilterSelected(filter),
            backgroundColor:
                isDarkMode ? AppTheme.surfaceDark : AppTheme.surfaceLight,
            selectedColor:
                isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight,
            checkmarkColor:
                isDarkMode ? AppTheme.onPrimaryDark : AppTheme.onPrimaryLight,
            side: BorderSide(
              color: isSelected
                  ? (isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight)
                  : (isDarkMode ? AppTheme.dividerDark : AppTheme.dividerLight),
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          );
        },
      ),
    );
  }
}
