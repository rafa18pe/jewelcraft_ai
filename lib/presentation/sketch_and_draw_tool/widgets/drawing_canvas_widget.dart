import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';

import '../../../core/app_export.dart';

class DrawingCanvasWidget extends StatefulWidget {
  final DrawingController drawingController;
  final bool showGrid;
  final bool showReferenceImage;
  final String? referenceImageUrl;
  final double canvasOpacity;

  const DrawingCanvasWidget({
    Key? key,
    required this.drawingController,
    this.showGrid = false,
    this.showReferenceImage = false,
    this.referenceImageUrl,
    this.canvasOpacity = 1.0,
  }) : super(key: key);

  @override
  State<DrawingCanvasWidget> createState() => _DrawingCanvasWidgetState();
}

class _DrawingCanvasWidgetState extends State<DrawingCanvasWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          // Reference image overlay (ghost mode)
          if (widget.showReferenceImage && widget.referenceImageUrl != null)
            Positioned.fill(
              child: Opacity(
                opacity: 0.3,
                child: CustomImageWidget(
                  imageUrl: widget.referenceImageUrl!,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
            ),

          // Grid overlay
          if (widget.showGrid)
            Positioned.fill(
              child: CustomPaint(
                painter: GridPainter(
                  gridColor: AppTheme.lightTheme.colorScheme.outline
                      .withOpacity(0.3),
                ),
              ),
            ),

          // Main drawing canvas
          Positioned.fill(
            child: Opacity(
              opacity: widget.canvasOpacity,
              child: DrawingBoard(
                controller: widget.drawingController,
                background: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.transparent,
                ),
                showDefaultActions: false,
                showDefaultTools: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  final Color gridColor;
  final double gridSize;

  GridPainter({
    required this.gridColor,
    this.gridSize = 20.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = gridColor
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    // Draw vertical lines
    for (double x = 0; x <= size.width; x += gridSize) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Draw horizontal lines
    for (double y = 0; y <= size.height; y += gridSize) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
