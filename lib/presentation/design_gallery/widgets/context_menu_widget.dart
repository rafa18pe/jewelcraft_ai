import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ContextMenuWidget extends StatelessWidget {
  final Map<String, dynamic> design;
  final Function(String) onActionSelected;

  const ContextMenuWidget({
    Key? key,
    required this.design,
    required this.onActionSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppTheme.surfaceDark : AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? AppTheme.shadowDark : AppTheme.shadowLight,
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: (isDarkMode ? AppTheme.primaryDark : AppTheme.primaryLight)
                  .withOpacity(0.1),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CustomImageWidget(
                    imageUrl: design['imageUrl'] as String,
                    width: 12.w,
                    height: 12.w,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        design['title'] as String,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isDarkMode
                                  ? AppTheme.textPrimaryDark
                                  : AppTheme.textPrimaryLight,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        design['date'] as String,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: isDarkMode
                                  ? AppTheme.textSecondaryDark
                                  : AppTheme.textSecondaryLight,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Menu items
          _buildMenuItem(
            context,
            icon: 'edit',
            title: 'Editar',
            onTap: () => onActionSelected('edit'),
          ),
          _buildMenuItem(
            context,
            icon: 'content_copy',
            title: 'Duplicar',
            onTap: () => onActionSelected('duplicate'),
          ),
          _buildMenuItem(
            context,
            icon: 'share',
            title: 'Compartir',
            onTap: () => onActionSelected('share'),
          ),
          _buildMenuItem(
            context,
            icon: 'favorite_border',
            title: 'Agregar a Favoritos',
            onTap: () => onActionSelected('favorite'),
          ),
          _buildMenuItem(
            context,
            icon: 'delete_outline',
            title: 'Eliminar',
            onTap: () => onActionSelected('delete'),
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required String icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: isDestructive
                  ? (isDarkMode ? AppTheme.errorDark : AppTheme.errorLight)
                  : (isDarkMode
                      ? AppTheme.textSecondaryDark
                      : AppTheme.textSecondaryLight),
              size: 20,
            ),
            SizedBox(width: 4.w),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDestructive
                        ? (isDarkMode
                            ? AppTheme.errorDark
                            : AppTheme.errorLight)
                        : (isDarkMode
                            ? AppTheme.textPrimaryDark
                            : AppTheme.textPrimaryLight),
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
