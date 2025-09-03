import 'package:flutter/material.dart';
import '../presentation/design_gallery/design_gallery.dart';
import '../presentation/voice_to_jewelry/voice_to_jewelry.dart';
import '../presentation/stl_export_and_sharing/stl_export_and_sharing.dart';
import '../presentation/ai_text_to_jewelry/ai_text_to_jewelry.dart';
import '../presentation/sketch_and_draw_tool/sketch_and_draw_tool.dart';
import '../presentation/3d_model_viewer/3d_model_viewer.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String designGallery = '/design-gallery';
  static const String voiceToJewelry = '/voice-to-jewelry';
  static const String stlExportAndSharing = '/stl-export-and-sharing';
  static const String aiTextToJewelry = '/ai-text-to-jewelry';
  static const String sketchAndDrawTool = '/sketch-and-draw-tool';
  static const String threeDModelViewer = '/3d-model-viewer';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const DesignGallery(),
    designGallery: (context) => const DesignGallery(),
    voiceToJewelry: (context) => const VoiceToJewelry(),
    stlExportAndSharing: (context) => const StlExportAndSharing(),
    aiTextToJewelry: (context) => const AiTextToJewelry(),
    sketchAndDrawTool: (context) => const SketchAndDrawTool(),
    threeDModelViewer: (context) => const ThreeDModelViewer(),
    // TODO: Add your other routes here
  };
}
