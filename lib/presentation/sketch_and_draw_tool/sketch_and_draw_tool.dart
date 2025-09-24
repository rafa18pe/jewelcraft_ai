import 'dart:convert';
import 'dart:io' if (dart.library.io) 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:universal_html/html.dart' as html
    if (dart.library.io) 'package:jewelcraft_ai/web/html_stub.dart' as html;

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import '../../widgets/custom_image_widget.dart';
import './widgets/action_buttons_widget.dart';
import './widgets/drawing_canvas_widget.dart';
import './widgets/drawing_toolbar_widget.dart';
import './widgets/export_options_widget.dart';
import './widgets/layers_panel_widget.dart';
import 'widgets/action_buttons_widget.dart';
import 'widgets/drawing_canvas_widget.dart';
import 'widgets/drawing_toolbar_widget.dart';
import 'widgets/export_options_widget.dart';
import 'widgets/layers_panel_widget.dart';

class SketchAndDrawTool extends StatefulWidget {
  const SketchAndDrawTool({Key? key}) : super(key: key);

  @override
  State<SketchAndDrawTool> createState() => _SketchAndDrawToolState();
}

class _SketchAndDrawToolState extends State<SketchAndDrawTool>
    with TickerProviderStateMixin {
  late DrawingController _drawingController;
  late TransformationController _transformationController;
  late AnimationController _toolbarAnimationController;

  bool _isToolbarCollapsed = false;
  bool _showGrid = false;
  bool _showReferenceImage = false;
  bool _isProcessingAI = false;
  String? _referenceImageUrl;
  double _canvasOpacity = 1.0;

  // Layers management
  List<LayerData> _layers = [];
  int _selectedLayerIndex = 0;

  // Gesture detection
  int _tapCount = 0;
  DateTime? _lastTapTime;

  // Auto-save
  bool _hasUnsavedChanges = false;

  final List<Map<String, dynamic>> _mockJewelryTemplates = [
    {
      "id": 1,
      "name": "Anillo de Compromiso Clásico",
      "category": "Anillos",
      "imageUrl":
          "https://images.pexels.com/photos/1232931/pexels-photo-1232931.jpeg?auto=compress&cs=tinysrgb&w=800",
      "description": "Diseño elegante con diamante solitario",
    },
    {
      "id": 2,
      "name": "Collar de Perlas Vintage",
      "category": "Collares",
      "imageUrl":
          "https://images.pexels.com/photos/1454171/pexels-photo-1454171.jpeg?auto=compress&cs=tinysrgb&w=800",
      "description": "Estilo vintage con perlas naturales",
    },
    {
      "id": 3,
      "name": "Aretes de Oro Rosa",
      "category": "Aretes",
      "imageUrl":
          "https://images.pexels.com/photos/1454172/pexels-photo-1454172.jpeg?auto=compress&cs=tinysrgb&w=800",
      "description": "Diseño moderno en oro rosa 18k",
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeLayers();
    _setupGestureDetection();
  }

  void _initializeControllers() {
    _drawingController = DrawingController();
    _transformationController = TransformationController();
    _toolbarAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  void _initializeLayers() {
    _layers = [
      LayerData(
        id: 'layer_1',
        name: 'Capa Base',
        isVisible: true,
        opacity: 1.0,
      ),
    ];
  }

  void _setupGestureDetection() {
    // Setup gesture recognition for undo/redo
    // This would be implemented with GestureDetector in the build method
  }

  @override
  void dispose() {
    _drawingController.dispose();
    _transformationController.dispose();
    _toolbarAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          // Main drawing area
          Positioned.fill(
            child: GestureDetector(
              onTap: _handleCanvasTap,
              onDoubleTap: _handleDoubleTap,
              child: InteractiveViewer(
                transformationController: _transformationController,
                minScale: 0.1,
                maxScale: 5.0,
                child: DrawingCanvasWidget(
                  drawingController: _drawingController,
                  showGrid: _showGrid,
                  showReferenceImage: _showReferenceImage,
                  referenceImageUrl: _referenceImageUrl,
                  canvasOpacity: _canvasOpacity,
                ),
              ),
            ),
          ),

          // Action buttons overlay
          ActionButtonsWidget(
            onUndo: _canUndo() ? _undo : null,
            onRedo: _canRedo() ? _redo : null,
            onZoomIn: _zoomIn,
            onZoomOut: _zoomOut,
            onFitToScreen: _fitToScreen,
            onToggleGrid: _toggleGrid,
            onToggleReference: _toggleReferenceImage,
            onLayers: _showLayersPanel,
            onExport: _showExportOptions,
            canUndo: _canUndo(),
            canRedo: _canRedo(),
            showGrid: _showGrid,
            showReference: _showReferenceImage,
          ),

          // AI processing indicator
          if (_isProcessingAI)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.5),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          color: AppTheme.lightTheme.primaryColor,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Procesando con IA...',
                          style: AppTheme.lightTheme.textTheme.bodyLarge,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Analizando y mejorando tu diseño',
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Drawing toolbar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: DrawingToolbarWidget(
              drawingController: _drawingController,
              onUndo: _canUndo() ? _undo : null,
              onRedo: _canRedo() ? _redo : null,
              onClear: _clearCanvas,
              onAICorrection: _processAICorrection,
              isCollapsed: _isToolbarCollapsed,
              onToggleCollapse: _toggleToolbar,
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'Herramienta de Dibujo',
        style: AppTheme.lightTheme.textTheme.titleLarge,
      ),
      leading: IconButton(
        onPressed: () => _handleBackPress(),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          size: 24,
          color: AppTheme.lightTheme.colorScheme.onSurface,
        ),
      ),
      actions: [
        IconButton(
          onPressed: _importReferenceImage,
          icon: CustomIconWidget(
            iconName: 'photo_library',
            size: 24,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
          tooltip: 'Importar imagen',
        ),
        IconButton(
          onPressed: _showTemplateGallery,
          icon: CustomIconWidget(
            iconName: 'collections',
            size: 24,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
          tooltip: 'Plantillas',
        ),
        PopupMenuButton<String>(
          onSelected: _handleMenuSelection,
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'save',
              child: Text('Guardar proyecto'),
            ),
            const PopupMenuItem(
              value: 'load',
              child: Text('Cargar proyecto'),
            ),
            const PopupMenuItem(
              value: 'new',
              child: Text('Nuevo proyecto'),
            ),
            const PopupMenuItem(
              value: 'settings',
              child: Text('Configuración'),
            ),
          ],
        ),
      ],
    );
  }

  void _handleCanvasTap() {
    final now = DateTime.now();
    if (_lastTapTime != null &&
        now.difference(_lastTapTime!).inMilliseconds < 300) {
      _tapCount++;
    } else {
      _tapCount = 1;
    }
    _lastTapTime = now;

    // Handle gesture shortcuts
    if (_tapCount == 2) {
      // Two-finger tap for undo (simulated with double tap)
      if (_canUndo()) _undo();
    } else if (_tapCount == 3) {
      // Three-finger tap for redo (simulated with triple tap)
      if (_canRedo()) _redo();
      _tapCount = 0;
    }
  }

  void _handleDoubleTap() {
    _fitToScreen();
  }

  void _handleBackPress() {
    if (_hasUnsavedChanges) {
      _showUnsavedChangesDialog();
    } else {
      Navigator.pop(context);
    }
  }

  void _showUnsavedChangesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Cambios sin guardar',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        content: Text(
          '¿Quieres guardar los cambios antes de salir?',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Descartar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _saveProject();
            },
            child: Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'save':
        _saveProject();
        break;
      case 'load':
        _loadProject();
        break;
      case 'new':
        _newProject();
        break;
      case 'settings':
        _showSettings();
        break;
    }
  }

  // Drawing controls
  bool _canUndo() {
    return _drawingController.canUndo();
  }

  bool _canRedo() {
    return _drawingController.canRedo();
  }

  void _undo() {
    _drawingController.undo();
    setState(() => _hasUnsavedChanges = true);
  }

  void _redo() {
    _drawingController.redo();
    setState(() => _hasUnsavedChanges = true);
  }

  void _clearCanvas() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Limpiar lienzo',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        content: Text(
          '¿Estás seguro de que quieres limpiar todo el lienzo?',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _drawingController.clear();
              setState(() => _hasUnsavedChanges = true);
            },
            child: Text(
              'Limpiar',
              style: TextStyle(color: AppTheme.lightTheme.colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  // View controls
  void _zoomIn() {
    final currentScale = _transformationController.value.getMaxScaleOnAxis();
    if (currentScale < 5.0) {
      _transformationController.value = Matrix4.identity()
        ..scale(currentScale * 1.2);
    }
  }

  void _zoomOut() {
    final currentScale = _transformationController.value.getMaxScaleOnAxis();
    if (currentScale > 0.1) {
      _transformationController.value = Matrix4.identity()
        ..scale(currentScale * 0.8);
    }
  }

  void _fitToScreen() {
    _transformationController.value = Matrix4.identity();
  }

  void _toggleGrid() {
    setState(() => _showGrid = !_showGrid);
  }

  void _toggleReferenceImage() {
    if (_referenceImageUrl == null) {
      _importReferenceImage();
    } else {
      setState(() => _showReferenceImage = !_showReferenceImage);
    }
  }

  void _toggleToolbar() {
    setState(() => _isToolbarCollapsed = !_isToolbarCollapsed);
    if (_isToolbarCollapsed) {
      _toolbarAnimationController.forward();
    } else {
      _toolbarAnimationController.reverse();
    }
  }

  // AI processing
  Future<void> _processAICorrection() async {
    setState(() => _isProcessingAI = true);

    try {
      // Simulate AI processing
      await Future.delayed(const Duration(seconds: 3));

      // Mock AI suggestions
      final suggestions = [
        "Simetría mejorada en el diseño principal",
        "Proporciones ajustadas para mejor balance",
        "Detalles refinados en las gemas",
        "Líneas suavizadas para mejor acabado",
      ];

      _showAISuggestions(suggestions);
    } catch (e) {
      _showErrorMessage('Error al procesar con IA: ${e.toString()}');
    } finally {
      setState(() => _isProcessingAI = false);
    }
  }

  void _showAISuggestions(List<String> suggestions) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'auto_fix_high',
              size: 24,
              color: AppTheme.lightTheme.primaryColor,
            ),
            SizedBox(width: 2.w),
            Text(
              'Sugerencias de IA',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'La IA ha analizado tu diseño y sugiere las siguientes mejoras:',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            ...suggestions
                .map((suggestion) => Padding(
                      padding: EdgeInsets.only(bottom: 1.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomIconWidget(
                            iconName: 'check_circle',
                            size: 16,
                            color: AppTheme.getSuccessColor(true),
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Text(
                              suggestion,
                              style: AppTheme.lightTheme.textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Ignorar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _applyAICorrections();
            },
            child: Text('Aplicar'),
          ),
        ],
      ),
    );
  }

  void _applyAICorrections() {
    // Mock AI corrections application
    Fluttertoast.showToast(
      msg: "Correcciones de IA aplicadas exitosamente",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
    setState(() => _hasUnsavedChanges = true);
  }

  // Image import
  Future<void> _importReferenceImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          _referenceImageUrl = image.path;
          _showReferenceImage = true;
        });

        Fluttertoast.showToast(
          msg: "Imagen de referencia cargada",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } catch (e) {
      _showErrorMessage('Error al cargar imagen: ${e.toString()}');
    }
  }

  // Template gallery
  void _showTemplateGallery() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Plantillas de Joyería',
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
              child: GridView.builder(
                padding: EdgeInsets.all(4.w),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 3.w,
                  mainAxisSpacing: 2.h,
                  childAspectRatio: 0.8,
                ),
                itemCount: _mockJewelryTemplates.length,
                itemBuilder: (context, index) {
                  final template = _mockJewelryTemplates[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      _loadTemplate(template);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12)),
                              child: CustomImageWidget(
                                imageUrl: template["imageUrl"] as String,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(2.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  template["name"] as String,
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  template["description"] as String,
                                  style:
                                      AppTheme.lightTheme.textTheme.bodySmall,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _loadTemplate(Map<String, dynamic> template) {
    setState(() {
      _referenceImageUrl = template["imageUrl"] as String;
      _showReferenceImage = true;
    });

    Fluttertoast.showToast(
      msg: "Plantilla '${template["name"]}' cargada como referencia",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  // Layers management
  void _showLayersPanel() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LayersPanelWidget(
        layers: _layers,
        selectedLayerIndex: _selectedLayerIndex,
        onLayerSelected: _selectLayer,
        onLayerVisibilityToggled: _toggleLayerVisibility,
        onLayerOpacityChanged: _changeLayerOpacity,
        onAddLayer: _addLayer,
        onDeleteLayer: _deleteLayer,
        onReorderLayers: _reorderLayers,
      ),
    );
  }

  void _selectLayer(int index) {
    setState(() => _selectedLayerIndex = index);
  }

  void _toggleLayerVisibility(int index) {
    setState(() {
      _layers[index] = _layers[index].copyWith(
        isVisible: !_layers[index].isVisible,
      );
    });
  }

  void _changeLayerOpacity(int index, double opacity) {
    setState(() {
      _layers[index] = _layers[index].copyWith(opacity: opacity);
    });
  }

  void _addLayer() {
    setState(() {
      _layers.add(LayerData(
        id: 'layer_${_layers.length + 1}',
        name: 'Capa ${_layers.length + 1}',
        isVisible: true,
        opacity: 1.0,
      ));
    });
  }

  void _deleteLayer(int index) {
    if (_layers.length > 1) {
      setState(() {
        _layers.removeAt(index);
        if (_selectedLayerIndex >= _layers.length) {
          _selectedLayerIndex = _layers.length - 1;
        }
      });
    }
  }

  void _reorderLayers(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final layer = _layers.removeAt(oldIndex);
      _layers.insert(newIndex, layer);
    });
  }

  // Export functionality
  void _showExportOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ExportOptionsWidget(
        onExportPNG: _exportPNG,
        onExportSVG: _exportSVG,
        onExportTo3D: _exportTo3D,
        onSaveToGallery: _saveToGallery,
        onShareDesign: _shareDesign,
      ),
    );
  }

  Future<void> _exportPNG() async {
    try {
      // Get drawing data
      final drawingData = await _drawingController.getImageData();

      if (drawingData != null) {
        await _downloadFile(
          base64Encode(drawingData.buffer.asUint8List()),
          'jewelry_design_${DateTime.now().millisecondsSinceEpoch}.png',
          'image/png',
        );

        Fluttertoast.showToast(
          msg: "Diseño exportado como PNG",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } catch (e) {
      _showErrorMessage('Error al exportar PNG: ${e.toString()}');
    }
  }

  Future<void> _exportSVG() async {
    try {
      // Mock SVG export
      final svgContent = '''<?xml version="1.0" encoding="UTF-8"?>
<svg width="800" height="600" xmlns="http://www.w3.org/2000/svg">
  <rect width="100%" height="100%" fill="white"/>
  <text x="400" y="300" text-anchor="middle" font-family="Arial" font-size="24">
    Diseño de Joyería Exportado
  </text>
</svg>''';

      await _downloadFile(
          svgContent,
          'jewelry_design_${DateTime.now().millisecondsSinceEpoch}.svg',
          'image/svg+xml');

      Fluttertoast.showToast(
        msg: "Diseño exportado como SVG",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } catch (e) {
      _showErrorMessage('Error al exportar SVG: ${e.toString()}');
    }
  }

  void _exportTo3D() {
    Navigator.pushNamed(context, '/3d-model-viewer');
  }

  Future<void> _saveToGallery() async {
    try {
      final drawingData = await _drawingController.getImageData();

      if (drawingData != null) {
        // Mock save to gallery
        Fluttertoast.showToast(
          msg: "Diseño guardado en la galería",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } catch (e) {
      _showErrorMessage('Error al guardar en galería: ${e.toString()}');
    }
  }

  Future<void> _shareDesign() async {
    try {
      // Mock share functionality
      Fluttertoast.showToast(
        msg: "Compartiendo diseño...",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } catch (e) {
      _showErrorMessage('Error al compartir: ${e.toString()}');
    }
  }

  // File operations
  Future<void> _downloadFile(
      String content, String filename, String mimeType) async {
    try {
      if (kIsWeb) {
        final bytes = base64Decode(content);
        final blob = html.Blob([bytes], mimeType);
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
    } catch (e) {
      throw Exception('Error downloading file: $e');
    }
  }

  // Project management
  Future<void> _saveProject() async {
    try {
      final projectData = {
        'name': 'Proyecto_${DateTime.now().millisecondsSinceEpoch}',
        'created': DateTime.now().toIso8601String(),
        'layers': _layers
            .map((layer) => {
                  'id': layer.id,
                  'name': layer.name,
                  'isVisible': layer.isVisible,
                  'opacity': layer.opacity,
                })
            .toList(),
        'settings': {
          'showGrid': _showGrid,
          'referenceImageUrl': _referenceImageUrl,
        },
      };

      final jsonData = jsonEncode(projectData);
      await _downloadFile(
          jsonData,
          'jewelry_project_${DateTime.now().millisecondsSinceEpoch}.json',
          'application/json');

      setState(() => _hasUnsavedChanges = false);

      Fluttertoast.showToast(
        msg: "Proyecto guardado exitosamente",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } catch (e) {
      _showErrorMessage('Error al guardar proyecto: ${e.toString()}');
    }
  }

  Future<void> _loadProject() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null) {
        final fileBytes = kIsWeb
            ? result.files.first.bytes
            : await File(result.files.first.path!).readAsBytes();

        if (fileBytes != null) {
          final jsonString = utf8.decode(fileBytes);
          final projectData = jsonDecode(jsonString) as Map<String, dynamic>;

          // Load project data
          final layersData =
              (projectData['layers'] as List).cast<Map<String, dynamic>>();
          _layers = layersData
              .map((layerData) => LayerData(
                    id: layerData['id'] as String,
                    name: layerData['name'] as String,
                    isVisible: layerData['isVisible'] as bool,
                    opacity: (layerData['opacity'] as num).toDouble(),
                  ))
              .toList();

          final settings = projectData['settings'] as Map<String, dynamic>;
          setState(() {
            _showGrid = settings['showGrid'] as bool;
            _referenceImageUrl = settings['referenceImageUrl'] as String?;
            _selectedLayerIndex = 0;
            _hasUnsavedChanges = false;
          });

          Fluttertoast.showToast(
            msg: "Proyecto cargado exitosamente",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
      }
    } catch (e) {
      _showErrorMessage('Error al cargar proyecto: ${e.toString()}');
    }
  }

  void _newProject() {
    if (_hasUnsavedChanges) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Nuevo proyecto',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          content: Text(
            '¿Quieres guardar los cambios del proyecto actual?',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _resetProject();
              },
              child: Text('Descartar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _saveProject().then((_) => _resetProject());
              },
              child: Text('Guardar y continuar'),
            ),
          ],
        ),
      );
    } else {
      _resetProject();
    }
  }

  void _resetProject() {
    _drawingController.clear();
    _initializeLayers();
    setState(() {
      _selectedLayerIndex = 0;
      _showGrid = false;
      _showReferenceImage = false;
      _referenceImageUrl = null;
      _hasUnsavedChanges = false;
    });
    _fitToScreen();
  }

  void _showSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Configuración',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Opacidad del lienzo'),
              subtitle: Slider(
                value: _canvasOpacity,
                min: 0.1,
                max: 1.0,
                divisions: 9,
                onChanged: (value) {
                  setState(() => _canvasOpacity = value);
                },
              ),
            ),
            SwitchListTile(
              title: Text('Auto-guardado'),
              value: true,
              onChanged: (value) {
                // Mock auto-save toggle
              },
            ),
            SwitchListTile(
              title: Text('Detección de presión'),
              value: true,
              onChanged: (value) {
                // Mock pressure detection toggle
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showErrorMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.error,
      textColor: Colors.white,
    );
  }
}