import 'dart:convert';
import 'dart:io' if (dart.library.io) 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:universal_html/html.dart' as html;

import '../../core/app_export.dart';
import './widgets/advanced_settings_widget.dart';
import './widgets/export_history_widget.dart';
import './widgets/export_options_card.dart';
import './widgets/export_progress_widget.dart';
import './widgets/file_info_widget.dart';
import './widgets/preview_thumbnail_widget.dart';
import './widgets/qr_code_widget.dart';
import './widgets/quality_selector_widget.dart';

class StlExportAndSharing extends StatefulWidget {
  const StlExportAndSharing({Key? key}) : super(key: key);

  @override
  State<StlExportAndSharing> createState() => _StlExportAndSharingState();
}

class _StlExportAndSharingState extends State<StlExportAndSharing> {
  String selectedQuality = 'standard';
  bool isAdvancedExpanded = false;
  bool supportStructures = true;
  String printOrientation = 'auto';
  double scalingFactor = 1.0;
  bool isExporting = false;
  double exportProgress = 0.0;
  String currentExportStep = '';

  // Mock data for jewelry design
  final Map<String, dynamic> currentDesign = {
    "id": "design_001",
    "name": "Anillo_Solitario_Clasico.stl",
    "fileSize": "2.4 MB",
    "printTime": "45 min",
    "materialCost": "1,250.00",
    "previewImage":
        "https://images.pexels.com/photos/1191531/pexels-photo-1191531.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    "qrData": "https://jewelcraft.ai/download/design_001",
  };

  final List<Map<String, dynamic>> exportHistory = [
    {
      "fileName": "Anillo_Compromiso_Vintage.stl",
      "exportDate": "15/08/2024 14:30",
      "fileSize": "3.1 MB",
      "quality": "Alta",
    },
    {
      "fileName": "Collar_Perlas_Moderno.stl",
      "exportDate": "12/08/2024 09:15",
      "fileSize": "1.8 MB",
      "quality": "Estándar",
    },
    {
      "fileName": "Pulsera_Oro_Trenzada.stl",
      "exportDate": "10/08/2024 16:45",
      "fileSize": "2.7 MB",
      "quality": "Alta",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      bottomSheet: _buildBottomSheet(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'Exportar y Compartir',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.lightTheme.colorScheme.onSurface,
          size: 6.w,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => _showHelpDialog(context),
          icon: CustomIconWidget(
            iconName: 'help_outline',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 6.w,
          ),
        ),
      ],
      elevation: 0,
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 3D Model Preview Background
          Container(
            width: double.infinity,
            height: 30.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppTheme.lightTheme.primaryColor.withOpacity(0.1),
                  AppTheme.lightTheme.scaffoldBackgroundColor,
                ],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'view_in_ar',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 20.w,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Modelo 3D Listo',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppTheme.lightTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Text(
                    'Preparado para exportación',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ),

          // File Information
          FileInfoWidget(
            fileName: currentDesign['name'] as String,
            fileSize: currentDesign['fileSize'] as String,
            printTime: currentDesign['printTime'] as String,
            materialCost: currentDesign['materialCost'] as String,
          ),

          // Export Progress (shown when exporting)
          ExportProgressWidget(
            isExporting: isExporting,
            progress: exportProgress,
            currentStep: currentExportStep,
            onCancel: _cancelExport,
          ),

          // Quality Selector
          QualitySelectorWidget(
            selectedQuality: selectedQuality,
            onQualityChanged: (quality) {
              setState(() {
                selectedQuality = quality;
              });
            },
          ),

          // Advanced Settings
          AdvancedSettingsWidget(
            isExpanded: isAdvancedExpanded,
            onToggle: () {
              setState(() {
                isAdvancedExpanded = !isAdvancedExpanded;
              });
            },
            supportStructures: supportStructures,
            onSupportStructuresChanged: (value) {
              setState(() {
                supportStructures = value;
              });
            },
            printOrientation: printOrientation,
            onPrintOrientationChanged: (orientation) {
              setState(() {
                printOrientation = orientation;
              });
            },
            scalingFactor: scalingFactor,
            onScalingFactorChanged: (factor) {
              setState(() {
                scalingFactor = factor;
              });
            },
          ),

          // Preview Thumbnail
          PreviewThumbnailWidget(
            previewImageUrl: currentDesign['previewImage'] as String?,
            onPreviewTap: () => _navigateToModelViewer(),
          ),

          // QR Code for Transfer
          QrCodeWidget(
            qrData: currentDesign['qrData'] as String,
            onShare: _shareQrCode,
          ),

          // Export History
          ExportHistoryWidget(
            exportHistory: exportHistory,
            onRedownload: _redownloadFile,
          ),

          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildBottomSheet(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),

            // Export Options
            ExportOptionsCard(
              title: 'Exportar STL',
              subtitle: 'Descargar archivo para impresión 3D',
              iconName: 'file_download',
              onTap: _exportStlFile,
              isEnabled: !isExporting,
            ),

            ExportOptionsCard(
              title: 'Compartir Archivo',
              subtitle: 'Enviar por aplicaciones instaladas',
              iconName: 'share',
              onTap: _shareFile,
              isEnabled: !isExporting,
            ),

            ExportOptionsCard(
              title: 'Enviar por Email',
              subtitle: 'Entrega profesional con especificaciones',
              iconName: 'email',
              onTap: _sendByEmail,
              isEnabled: !isExporting,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportStlFile() async {
    await _startExportProcess();

    try {
      final stlContent = _generateStlContent();
      final fileName = '${currentDesign['name']}';

      await _downloadFile(stlContent, fileName);

      _showSuccessMessage('Archivo STL exportado exitosamente');
      _addToExportHistory(fileName);
    } catch (e) {
      _showErrorMessage('Error al exportar archivo STL');
    } finally {
      _stopExportProcess();
    }
  }

  Future<void> _shareFile() async {
    await _startExportProcess();

    try {
      final stlContent = _generateStlContent();
      final fileName = '${currentDesign['name']}';

      if (kIsWeb) {
        await _downloadFile(stlContent, fileName);
        _showSuccessMessage('Archivo preparado para compartir');
      } else {
        // Mobile sharing implementation
        final directory = await getTemporaryDirectory();
        final file = File('${directory.path}/$fileName');
        await file.writeAsString(stlContent);

        // In real implementation, use share_plus package
        _showSuccessMessage('Archivo compartido exitosamente');
      }

      _addToExportHistory(fileName);
    } catch (e) {
      _showErrorMessage('Error al compartir archivo');
    } finally {
      _stopExportProcess();
    }
  }

  Future<void> _sendByEmail() async {
    await _startExportProcess();

    try {
      final stlContent = _generateStlContent();
      final fileName = '${currentDesign['name']}';
      final specifications = _generateSpecificationsPdf();

      // In real implementation, use email composition
      if (kIsWeb) {
        await _downloadFile(stlContent, fileName);
        await _downloadFile(specifications, 'especificaciones_impresion.pdf');
      }

      _showSuccessMessage('Email preparado con archivo y especificaciones');
      _addToExportHistory(fileName);
    } catch (e) {
      _showErrorMessage('Error al preparar email');
    } finally {
      _stopExportProcess();
    }
  }

  Future<void> _startExportProcess() async {
    setState(() {
      isExporting = true;
      exportProgress = 0.0;
      currentExportStep = 'Iniciando exportación...';
    });

    // Simulate export steps
    await _updateProgress(0.2, 'Procesando geometría 3D...');
    await _updateProgress(0.4, 'Aplicando configuraciones...');
    await _updateProgress(0.6, 'Optimizando para impresión...');
    await _updateProgress(0.8, 'Generando archivo STL...');
    await _updateProgress(1.0, 'Finalizando exportación...');
  }

  Future<void> _updateProgress(double progress, String step) async {
    await Future.delayed(Duration(milliseconds: 800));
    setState(() {
      exportProgress = progress;
      currentExportStep = step;
    });
  }

  void _stopExportProcess() {
    setState(() {
      isExporting = false;
      exportProgress = 0.0;
      currentExportStep = '';
    });
  }

  void _cancelExport() {
    _stopExportProcess();
    _showSuccessMessage('Exportación cancelada');
  }

  String _generateStlContent() {
    // Generate STL file content based on current settings
    final header = 'solid JewelCraftAI_${currentDesign['id']}\n';
    final footer = 'endsolid JewelCraftAI_${currentDesign['id']}\n';

    // Mock STL triangular facets
    final facets = List.generate(100, (index) {
      return '''  facet normal 0.0 0.0 1.0
    outer loop
      vertex ${(index * 0.1).toStringAsFixed(6)} 0.0 0.0
      vertex ${((index + 1) * 0.1).toStringAsFixed(6)} 1.0 0.0
      vertex ${(index * 0.1).toStringAsFixed(6)} 1.0 1.0
    endloop
  endfacet''';
    }).join('\n');

    return header + facets + '\n' + footer;
  }

  String _generateSpecificationsPdf() {
    final specifications = {
      'design_name': currentDesign['name'],
      'quality': selectedQuality,
      'support_structures': supportStructures,
      'print_orientation': printOrientation,
      'scaling_factor': '${(scalingFactor * 100).toInt()}%',
      'estimated_print_time': currentDesign['printTime'],
      'material_cost': '${currentDesign['materialCost']} MXN',
      'recommended_settings': {
        'layer_height': selectedQuality == 'high'
            ? '0.1mm'
            : selectedQuality == 'standard'
                ? '0.2mm'
                : '0.3mm',
        'infill': '20%',
        'print_speed': '50mm/s',
        'nozzle_temperature': '210°C',
        'bed_temperature': '60°C',
      }
    };

    return json.encode(specifications);
  }

  Future<void> _downloadFile(String content, String filename) async {
    if (kIsWeb) {
      final bytes = utf8.encode(content);
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", filename)
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$filename');
      await file.writeAsString(content);
    }
  }

  void _addToExportHistory(String fileName) {
    final now = DateTime.now();
    final exportEntry = {
      'fileName': fileName,
      'exportDate':
          '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
      'fileSize': currentDesign['fileSize'],
      'quality': _getQualityDisplayName(selectedQuality),
    };

    setState(() {
      exportHistory.insert(0, exportEntry);
    });
  }

  String _getQualityDisplayName(String quality) {
    switch (quality) {
      case 'draft':
        return 'Borrador';
      case 'standard':
        return 'Estándar';
      case 'high':
        return 'Alta';
      default:
        return 'Estándar';
    }
  }

  Future<void> _redownloadFile(Map<String, dynamic> export) async {
    try {
      final stlContent = _generateStlContent();
      await _downloadFile(stlContent, export['fileName'] as String);
      _showSuccessMessage('Archivo re-descargado exitosamente');
    } catch (e) {
      _showErrorMessage('Error al re-descargar archivo');
    }
  }

  void _shareQrCode() {
    // In real implementation, generate and share QR code image
    _showSuccessMessage('Código QR compartido');
  }

  void _navigateToModelViewer() {
    Navigator.pushNamed(context, '/3d-model-viewer');
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ayuda - Exportación STL'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Calidades de Exportación:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 1.h),
              Text('• Borrador: Exportación rápida con menor detalle'),
              Text('• Estándar: Balance entre calidad y velocidad'),
              Text('• Alta: Máximo detalle para impresión profesional'),
              SizedBox(height: 2.h),
              Text(
                'Configuraciones Avanzadas:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 1.h),
              Text('• Estructuras de soporte: Añade soportes automáticos'),
              Text('• Orientación: Optimiza la posición de impresión'),
              Text('• Escala: Ajusta el tamaño del modelo'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Entendido'),
          ),
        ],
      ),
    );
  }

  void _showSuccessMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.primaryColor,
      textColor: Colors.white,
    );
  }

  void _showErrorMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.error,
      textColor: Colors.white,
    );
  }
}
