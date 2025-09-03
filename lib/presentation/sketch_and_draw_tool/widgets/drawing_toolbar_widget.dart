import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class DrawingToolbarWidget extends StatefulWidget {
  final DrawingController drawingController;
  final VoidCallback? onUndo;
  final VoidCallback? onRedo;
  final VoidCallback? onClear;
  final VoidCallback? onAICorrection;
  final bool isCollapsed;
  final VoidCallback? onToggleCollapse;

  const DrawingToolbarWidget({
    Key? key,
    required this.drawingController,
    this.onUndo,
    this.onRedo,
    this.onClear,
    this.onAICorrection,
    this.isCollapsed = false,
    this.onToggleCollapse,
  }) : super(key: key);

  @override
  State<DrawingToolbarWidget> createState() => _DrawingToolbarWidgetState();
}

class _DrawingToolbarWidgetState extends State<DrawingToolbarWidget> {
  Color _selectedColor = Colors.black;
  double _brushSize = 3.0;
  double _opacity = 1.0;
  String _selectedTool = 'pencil';

  final List<Color> _jewelryColors = [
    Colors.black,
    Colors.grey[600]!,
    Colors.grey[400]!,
    const Color(0xFFB8860B), // Gold
    const Color(0xFF708090), // Silver
    const Color(0xFFCD853F), // Bronze
    const Color(0xFFFF6B6B), // Ruby red
    const Color(0xFF4ECDC4), // Emerald
    const Color(0xFF45B7D1), // Sapphire blue
    const Color(0xFF96CEB4), // Jade green
    const Color(0xFFDDA0DD), // Amethyst
    const Color(0xFFFFA07A), // Coral
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: widget.isCollapsed ? 8.h : 25.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Collapse handle
          GestureDetector(
            onTap: widget.onToggleCollapse,
            child: Container(
              width: 12.w,
              height: 1.h,
              margin: EdgeInsets.symmetric(vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          if (!widget.isCollapsed) ...[
            // Tool selection row
            Container(
              height: 6.h,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildToolButton(
                    icon: 'edit',
                    tool: 'pencil',
                    label: 'Lápiz',
                  ),
                  _buildToolButton(
                    icon: 'brush',
                    tool: 'pen',
                    label: 'Pincel',
                  ),
                  _buildToolButton(
                    icon: 'cleaning_services',
                    tool: 'eraser',
                    label: 'Borrador',
                  ),
                  _buildActionButton(
                    icon: 'auto_fix_high',
                    onTap: widget.onAICorrection,
                    label: 'IA',
                    color: AppTheme.lightTheme.primaryColor,
                  ),
                ],
              ),
            ),

            SizedBox(height: 1.h),

            // Color palette
            Container(
              height: 5.h,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                children: [
                  Text(
                    'Colores:',
                    style: AppTheme.lightTheme.textTheme.labelMedium,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _jewelryColors.length,
                      itemBuilder: (context, index) {
                        final color = _jewelryColors[index];
                        final isSelected = _selectedColor == color;

                        return GestureDetector(
                          onTap: () => _selectColor(color),
                          child: Container(
                            width: 8.w,
                            height: 8.w,
                            margin: EdgeInsets.only(right: 2.w),
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? AppTheme.lightTheme.primaryColor
                                    : AppTheme.lightTheme.colorScheme.outline,
                                width: isSelected ? 3 : 1,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 1.h),

            // Size and opacity sliders
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tamaño: ${_brushSize.toInt()}px',
                          style: AppTheme.lightTheme.textTheme.labelSmall,
                        ),
                        Slider(
                          value: _brushSize,
                          min: 1.0,
                          max: 20.0,
                          divisions: 19,
                          onChanged: (value) {
                            setState(() => _brushSize = value);
                            _updateDrawingStyle();
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Opacidad: ${(_opacity * 100).toInt()}%',
                          style: AppTheme.lightTheme.textTheme.labelSmall,
                        ),
                        Slider(
                          value: _opacity,
                          min: 0.1,
                          max: 1.0,
                          divisions: 9,
                          onChanged: (value) {
                            setState(() => _opacity = value);
                            _updateDrawingStyle();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildToolButton({
    required String icon,
    required String tool,
    required String label,
  }) {
    final isSelected = _selectedTool == tool;

    return GestureDetector(
      onTap: () => _selectTool(tool),
      child: Container(
        width: 15.w,
        height: 5.h,
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.outline,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: icon,
              size: 20,
              color: isSelected
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.onSurface,
            ),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: isSelected
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.lightTheme.colorScheme.onSurface,
                fontSize: 8.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String icon,
    required VoidCallback? onTap,
    required String label,
    Color? color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 15.w,
        height: 5.h,
        decoration: BoxDecoration(
          color: color?.withValues(alpha: 0.1) ?? Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color ?? AppTheme.lightTheme.colorScheme.outline,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: icon,
              size: 20,
              color: color ?? AppTheme.lightTheme.colorScheme.onSurface,
            ),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: color ?? AppTheme.lightTheme.colorScheme.onSurface,
                fontSize: 8.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectTool(String tool) {
    setState(() => _selectedTool = tool);
    widget.drawingController.setStyle(
      color: _selectedColor.withValues(alpha: _opacity),
      strokeWidth: _brushSize,
    );
  }

  void _selectColor(Color color) {
    setState(() => _selectedColor = color);
    _updateDrawingStyle();
  }

  void _updateDrawingStyle() {
    widget.drawingController.setStyle(
      color: _selectedColor.withValues(alpha: _opacity),
      strokeWidth: _brushSize,
    );
  }
}