import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DesignCardWidget extends StatelessWidget {
  final Map<String, dynamic> design;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const DesignCardWidget({
    Key? key,
    required this.design,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isDarkMode ? AppTheme.cardDark : AppTheme.cardLight,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: isDarkMode ? AppTheme.shadowDark : AppTheme.shadowLight,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image container
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: AspectRatio(
                aspectRatio: design['aspectRatio'] ?? 1.0,
                child: CustomImageWidget(
                  imageUrl: design['imageUrl'] as String,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Content section
            Padding(
              padding: EdgeInsets.all(3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    design['title'] as String,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isDarkMode
                              ? AppTheme.textPrimaryDark
                              : AppTheme.textPrimaryLight,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 1.h),

                  // Date
                  Text(
                    design['date'] as String,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isDarkMode
                              ? AppTheme.textSecondaryDark
                              : AppTheme.textSecondaryLight,
                        ),
                  ),

                  SizedBox(height: 1.5.h),

                  // Status badges
                  Wrap(
                    spacing: 1.w,
                    runSpacing: 0.5.h,
                    children: (design['badges'] as List<String>).map((badge) {
                      Color badgeColor;
                      switch (badge) {
                        case '3D Listo':
                          badgeColor = AppTheme.getSuccessColor(isDarkMode);
                          break;
                        case 'En Progreso':
                          badgeColor = AppTheme.getWarningColor(isDarkMode);
                          break;
                        case 'Borrador':
                          badgeColor = isDarkMode
                              ? AppTheme.textSecondaryDark
                              : AppTheme.textSecondaryLight;
                          break;
                        default:
                          badgeColor = isDarkMode
                              ? AppTheme.primaryDark
                              : AppTheme.primaryLight;
                      }

                      return Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: badgeColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: badgeColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          badge,
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: badgeColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
