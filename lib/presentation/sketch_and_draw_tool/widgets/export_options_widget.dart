import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ExportOptionsWidget extends StatefulWidget {
  final VoidCallback? onExportPNG;
  final VoidCallback? onExportSVG;
  final VoidCallback? onExportTo3D;
  final VoidCallback? onSaveToGallery;
  final VoidCallback? onShareDesign;

  const ExportOptionsWidget({
    Key? key,
    this.onExportPNG,
    this.onExportSVG,
    this.onExportTo3D,
    this.onSaveToGallery,
    this.onShareDesign,
  }) : super(key: key);

  @override
  State<ExportOptionsWidget> createState() => _ExportOptionsWidgetState();
}

class _ExportOptionsWidgetState extends State<ExportOptionsWidget> {
  String _selectedFormat = 'PNG';
  String _selectedResolution = 'Alta (2048x2048)';

  final List<String> _formats = ['PNG', 'SVG', 'JPG'];
  final List<String> _resolutions = [
    'Baja (512x512)',
    'Media (1024x1024)',
    'Alta (2048x2048)',
    'Ultra (4096x4096)',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
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
          // Header
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withOpacity(0.3),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Opciones de Exportación',
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    size: 20,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Format selection
                  Text(
                    'Formato',
                    style: AppTheme.lightTheme.textTheme.titleSmall,
                  ),
                  SizedBox(height: 2.h),
                  Wrap(
                    spacing: 2.w,
                    children: _formats.map((format) {
                      final isSelected = _selectedFormat == format;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedFormat = format),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 1.h),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.lightTheme.primaryColor
                                    .withOpacity(0.2)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.lightTheme.primaryColor
                                  : AppTheme.lightTheme.colorScheme.outline,
                            ),
                          ),
                          child: Text(
                            format,
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: isSelected
                                  ? AppTheme.lightTheme.primaryColor
                                  : AppTheme.lightTheme.colorScheme.onSurface,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 4.h),

                  // Resolution selection (only for raster formats)
                  if (_selectedFormat != 'SVG') ...[
                    Text(
                      'Resolución',
                      style: AppTheme.lightTheme.textTheme.titleSmall,
                    ),
                    SizedBox(height: 2.h),
                    Column(
                      children: _resolutions.map((resolution) {
                        final isSelected = _selectedResolution == resolution;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedResolution = resolution),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(3.w),
                            margin: EdgeInsets.only(bottom: 1.h),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.lightTheme.primaryColor
                                      .withOpacity(0.1)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected
                                    ? AppTheme.lightTheme.primaryColor
                                    : AppTheme.lightTheme.colorScheme.outline
                                        .withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                CustomIconWidget(
                                  iconName: isSelected
                                      ? 'radio_button_checked'
                                      : 'radio_button_unchecked',
                                  size: 20,
                                  color: isSelected
                                      ? AppTheme.lightTheme.primaryColor
                                      : AppTheme
                                          .lightTheme.colorScheme.onSurface
                                          .withOpacity(0.5),
                                ),
                                SizedBox(width: 3.w),
                                Text(
                                  resolution,
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 4.h),
                  ],

                  // Export options
                  Text(
                    'Opciones de Exportación',
                    style: AppTheme.lightTheme.textTheme.titleSmall,
                  ),
                  SizedBox(height: 2.h),

                  _buildExportOption(
                    icon: 'file_download',
                    title: 'Descargar archivo',
                    subtitle: 'Guardar en dispositivo',
                    onTap: _getExportFunction(),
                  ),

                  _buildExportOption(
                    icon: 'photo_library',
                    title: 'Guardar en galería',
                    subtitle: 'Agregar a fotos del dispositivo',
                    onTap: widget.onSaveToGallery,
                  ),

                  _buildExportOption(
                    icon: 'share',
                    title: 'Compartir diseño',
                    subtitle: 'Enviar a otras aplicaciones',
                    onTap: widget.onShareDesign,
                  ),

                  _buildExportOption(
                    icon: 'view_in_ar',
                    title: 'Continuar a 3D',
                    subtitle: 'Convertir a modelo 3D',
                    onTap: widget.onExportTo3D,
                    isHighlighted: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExportOption({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
    bool isHighlighted = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        margin: EdgeInsets.only(bottom: 2.h),
        decoration: BoxDecoration(
          color: isHighlighted
              ? AppTheme.lightTheme.primaryColor.withOpacity(0.1)
              : AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isHighlighted
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.outline
                    .withOpacity(0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: isHighlighted
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.lightTheme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: icon,
                  size: 24,
                  color: isHighlighted
                      ? Colors.white
                      : AppTheme.lightTheme.primaryColor,
                ),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isHighlighted
                          ? AppTheme.lightTheme.primaryColor
                          : AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'arrow_forward_ios',
              size: 16,
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }

  VoidCallback? _getExportFunction() {
    switch (_selectedFormat) {
      case 'PNG':
        return widget.onExportPNG;
      case 'SVG':
        return widget.onExportSVG;
      case 'JPG':
        return widget.onExportPNG; // Use PNG function for JPG as well
      default:
        return widget.onExportPNG;
    }
  }
}
