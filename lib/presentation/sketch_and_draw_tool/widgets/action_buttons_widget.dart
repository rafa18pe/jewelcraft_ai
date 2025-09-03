import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActionButtonsWidget extends StatelessWidget {
  final VoidCallback? onUndo;
  final VoidCallback? onRedo;
  final VoidCallback? onZoomIn;
  final VoidCallback? onZoomOut;
  final VoidCallback? onFitToScreen;
  final VoidCallback? onToggleGrid;
  final VoidCallback? onToggleReference;
  final VoidCallback? onLayers;
  final VoidCallback? onExport;
  final bool canUndo;
  final bool canRedo;
  final bool showGrid;
  final bool showReference;

  const ActionButtonsWidget({
    Key? key,
    this.onUndo,
    this.onRedo,
    this.onZoomIn,
    this.onZoomOut,
    this.onFitToScreen,
    this.onToggleGrid,
    this.onToggleReference,
    this.onLayers,
    this.onExport,
    this.canUndo = false,
    this.canRedo = false,
    this.showGrid = false,
    this.showReference = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Top-left: Undo/Redo buttons
        Positioned(
          top: 6.h,
          left: 4.w,
          child: Column(
            children: [
              _buildActionButton(
                icon: 'undo',
                onTap: canUndo ? onUndo : null,
                tooltip: 'Deshacer',
                isEnabled: canUndo,
              ),
              SizedBox(height: 1.h),
              _buildActionButton(
                icon: 'redo',
                onTap: canRedo ? onRedo : null,
                tooltip: 'Rehacer',
                isEnabled: canRedo,
              ),
            ],
          ),
        ),

        // Top-right: View controls
        Positioned(
          top: 6.h,
          right: 4.w,
          child: Column(
            children: [
              _buildActionButton(
                icon: 'zoom_in',
                onTap: onZoomIn,
                tooltip: 'Acercar',
              ),
              SizedBox(height: 1.h),
              _buildActionButton(
                icon: 'zoom_out',
                onTap: onZoomOut,
                tooltip: 'Alejar',
              ),
              SizedBox(height: 1.h),
              _buildActionButton(
                icon: 'fit_screen',
                onTap: onFitToScreen,
                tooltip: 'Ajustar pantalla',
              ),
            ],
          ),
        ),

        // Bottom-right: Additional controls
        Positioned(
          bottom: 30.h,
          right: 4.w,
          child: Column(
            children: [
              _buildToggleButton(
                icon: 'grid_on',
                onTap: onToggleGrid,
                tooltip: 'Cuadrícula',
                isActive: showGrid,
              ),
              SizedBox(height: 1.h),
              _buildToggleButton(
                icon: 'image',
                onTap: onToggleReference,
                tooltip: 'Imagen de referencia',
                isActive: showReference,
              ),
              SizedBox(height: 1.h),
              _buildActionButton(
                icon: 'layers',
                onTap: onLayers,
                tooltip: 'Capas',
              ),
              SizedBox(height: 1.h),
              _buildActionButton(
                icon: 'file_download',
                onTap: onExport,
                tooltip: 'Exportar',
                backgroundColor: AppTheme.lightTheme.primaryColor,
                iconColor: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String icon,
    required VoidCallback? onTap,
    required String tooltip,
    bool isEnabled = true,
    Color? backgroundColor,
    Color? iconColor,
  }) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: isEnabled ? onTap : null,
        child: Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: backgroundColor ?? AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.shadow,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: icon,
              size: 20,
              color: isEnabled
                  ? (iconColor ?? AppTheme.lightTheme.colorScheme.onSurface)
                  : AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.3),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButton({
    required String icon,
    required VoidCallback? onTap,
    required String tooltip,
    required bool isActive,
  }) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: isActive
                ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2)
                : AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isActive
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.shadow,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: icon,
              size: 20,
              color: isActive
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
