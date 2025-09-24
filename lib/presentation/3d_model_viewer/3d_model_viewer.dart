import 'dart:convert';
import 'dart:io' if (dart.library.io) 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:universal_html/html.dart'
    if (dart.library.io) 'package:jewelcraft_ai/web/html_stub.dart' as html;

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/export_options_widget.dart';
import './widgets/lighting_controls_widget.dart';
import './widgets/material_selector_widget.dart';
import './widgets/measurement_overlay_widget.dart';
import './widgets/model_controls_widget.dart';
import './widgets/viewing_modes_widget.dart';
import 'widgets/export_options_widget.dart';
import 'widgets/lighting_controls_widget.dart';
import 'widgets/material_selector_widget.dart';
import 'widgets/measurement_overlay_widget.dart';
import 'widgets/model_controls_widget.dart';
import 'widgets/viewing_modes_widget.dart';

class ThreeDModelViewer extends StatefulWidget {
  const ThreeDModelViewer({Key? key}) : super(key: key);

  @override
  State<ThreeDModelViewer> createState() => _ThreeDModelViewerState();
}

class _ThreeDModelViewerState extends State<ThreeDModelViewer>
    with TickerProviderStateMixin {
  // Model viewer state
  String _selectedMaterial = 'gold_18k';
  String _selectedLighting = 'studio';
  String _selectedViewingMode = 'solid';
  bool _isWireframe = false;
  bool _isAnimating = false;
  bool _showMeasurements = false;
  bool _useMetricUnits = true;
  bool _showBottomControls = true;

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Mock jewelry model data
  final Map<String, dynamic> _jewelryModel = {
    "id": "ring_001",
    "name": "Anillo de Compromiso Clásico",
    "description": "Elegante anillo de compromiso con diamante central y detalles ornamentales",
    "modelUrl": "https://modelviewer.dev/shared-assets/models/Astronaut.glb",
    "dimensions": {
      "width_mm": 15.2,
      "height_mm": 8.5,
      "depth_mm": 3.2,
      "weight_g": 2.8
    },
    "materials": {
      "gold_14k": {"density": 13.0, "color": "#DAA520"},
      "gold_18k": {"density": 15.6, "color": "#FFD700"},
      "silver_925": {"density": 10.4, "color": "#C0C0C0"},
      "platinum": {"density": 21.4, "color": "#E5E4E2"}
    },
    "created_at": "2025-09-03T16:20:44.296516"
  };

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _resetView() {
    setState(() {
      _selectedViewingMode = 'solid';
      _isWireframe = false;
      _isAnimating = false;
    });
    _showToast('Vista restablecida');
  }

  void _toggleWireframe() {
    setState(() {
      _isWireframe = !_isWireframe;
      _selectedViewingMode = _isWireframe ? 'wireframe' : 'solid';
    });
    _showToast(_isWireframe ? 'Vista alambre activada' : 'Vista sólida activada');
  }

  void _toggleAnimation() {
    setState(() {
      _isAnimating = !_isAnimating;
    });
    _showToast(_isAnimating ? 'Animación iniciada' : 'Animación pausada');
  }

  void _takeScreenshot() async {
    try {
      // Simulate screenshot capture
      await Future.delayed(const Duration(milliseconds: 500));
      _showToast('Captura guardada en galería');
    } catch (e) {
      _showToast('Error al capturar imagen');
    }
  }

  void _onMaterialChanged(String material) {
    setState(() {
      _selectedMaterial = material;
    });
    final materialData = (_jewelryModel['materials'] as Map<String, dynamic>)[material] as Map<String, dynamic>;
    final materialNames = {
      'gold_14k': 'Oro 14k',
      'gold_18k': 'Oro 18k',
      'silver_925': 'Plata 925',
      'platinum': 'Platino'
    };
    _showToast('Material cambiado a ${materialNames[material]}');
  }

  void _onLightingChanged(String lighting) {
    setState(() {
      _selectedLighting = lighting;
    });
    final lightingNames = {
      'studio': 'Iluminación de estudio',
      'natural': 'Luz natural',
      'dramatic': 'Iluminación dramática'
    };
    _showToast(lightingNames[lighting] ?? 'Iluminación cambiada');
  }

  void _onViewingModeChanged(String mode) {
    setState(() {
      _selectedViewingMode = mode;
      _isWireframe = mode == 'wireframe';
    });
    final modeNames = {
      'solid': 'Vista sólida',
      'wireframe': 'Vista alambre',
      'textured': 'Vista con textura',
      'xray': 'Vista rayos X'
    };
    _showToast(modeNames[mode] ?? 'Modo de vista cambiado');
  }

  void _toggleMeasurements() {
    setState(() {
      _showMeasurements = !_showMeasurements;
    });
  }

  void _toggleUnits() {
    setState(() {
      _useMetricUnits = !_useMetricUnits;
    });
    _showToast(_useMetricUnits ? 'Unidades métricas' : 'Unidades imperiales');
  }

  Future<void> _exportSTL() async {
    try {
      // Generate STL content
      final stlContent = _generateSTLContent();
      
      if (kIsWeb) {
        final bytes = utf8.encode(stlContent);
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download", "${_jewelryModel['name']}.stl")
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/${_jewelryModel['name']}.stl');
        await file.writeAsString(stlContent);
      }
      
      _showToast('Archivo STL exportado exitosamente');
    } catch (e) {
      _showToast('Error al exportar archivo STL');
    }
  }

  String _generateSTLContent() {
    // Generate basic STL file content for jewelry model
    return '''solid ${_jewelryModel['name']}
  facet normal 0.0 0.0 1.0
    outer loop
      vertex 0.0 0.0 0.0
      vertex 1.0 0.0 0.0
      vertex 0.5 1.0 0.0
    endloop
  endfacet
endsolid ${_jewelryModel['name']}''';
  }

  Future<void> _exportRender() async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      _showToast('Render de alta resolución exportado');
    } catch (e) {
      _showToast('Error al exportar render');
    }
  }

  Future<void> _shareAR() async {
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      _showToast('Modelo AR compartido exitosamente');
    } catch (e) {
      _showToast('Error al compartir modelo AR');
    }
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      textColor: AppTheme.lightTheme.colorScheme.onSurface,
    );
  }

  void _navigateToScreen(String route) {
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Stack(
          children: [
            // 3D Model Viewer
            _buildModelViewer(),
            
            // Measurement Overlay
            MeasurementOverlayWidget(
              isVisible: _showMeasurements,
              useMetric: _useMetricUnits,
              onToggleUnit: _toggleUnits,
              onToggleVisibility: _toggleMeasurements,
            ),
            
            // Bottom Controls
            if (_showBottomControls) _buildBottomControls(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: Colors.white,
          size: 24,
        ),
      ),
      title: Text(
        'Visor 3D',
        style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        IconButton(
          onPressed: _toggleMeasurements,
          icon: CustomIconWidget(
            iconName: 'straighten',
            color: _showMeasurements ? AppTheme.lightTheme.primaryColor : Colors.white,
            size: 24,
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _showBottomControls = !_showBottomControls;
            });
          },
          icon: CustomIconWidget(
            iconName: _showBottomControls ? 'keyboard_arrow_down' : 'keyboard_arrow_up',
            color: Colors.white,
            size: 24,
          ),
        ),
        PopupMenuButton<String>(
          onSelected: _navigateToScreen,
          icon: CustomIconWidget(
            iconName: 'more_vert',
            color: Colors.white,
            size: 24,
          ),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: '/ai-text-to-jewelry',
              child: Text('Texto a Joyería'),
            ),
            const PopupMenuItem(
              value: '/voice-to-jewelry',
              child: Text('Voz a Joyería'),
            ),
            const PopupMenuItem(
              value: '/sketch-and-draw-tool',
              child: Text('Herramienta de Dibujo'),
            ),
            const PopupMenuItem(
              value: '/stl-export-and-sharing',
              child: Text('Exportar y Compartir'),
            ),
            const PopupMenuItem(
              value: '/design-gallery',
              child: Text('Galería de Diseños'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildModelViewer() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: ModelViewer(
        backgroundColor: Colors.black,
        src: _jewelryModel['modelUrl'] as String,
        alt: _jewelryModel['description'] as String,
        ar: true,
        arModes: const ['scene-viewer', 'webxr', 'quick-look'],
        autoRotate: _isAnimating,
        cameraControls: true,
        disableZoom: false,
        loading: Loading.eager,
        interactionPrompt: InteractionPrompt.none,
        shadowIntensity: _selectedLighting == 'dramatic' ? 2.0 : 1.0,
        shadowSoftness: _selectedLighting == 'natural' ? 0.8 : 0.5,
      ),
    );
  }

  Widget _buildBottomControls() {
    return SlideTransition(
      position: _slideAnimation,
      child: Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.8),
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Model Controls
              ModelControlsWidget(
                onResetView: _resetView,
                onToggleWireframe: _toggleWireframe,
                onToggleAnimation: _toggleAnimation,
                onTakeScreenshot: _takeScreenshot,
                isWireframe: _isWireframe,
                isAnimating: _isAnimating,
              ),
              
              SizedBox(height: 2.h),
              
              // Viewing Modes
              ViewingModesWidget(
                selectedMode: _selectedViewingMode,
                onModeChanged: _onViewingModeChanged,
              ),
              
              SizedBox(height: 2.h),
              
              // Material Selector and Lighting Controls Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: MaterialSelectorWidget(
                      selectedMaterial: _selectedMaterial,
                      onMaterialChanged: _onMaterialChanged,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: LightingControlsWidget(
                      selectedLighting: _selectedLighting,
                      onLightingChanged: _onLightingChanged,
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 2.h),
              
              // Export Options
              ExportOptionsWidget(
                onExportSTL: _exportSTL,
                onExportRender: _exportRender,
                onShareAR: _shareAR,
              ),
              
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }
}