import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/custom_header_widget.dart';
import './widgets/processing_overlay_widget.dart';
import './widgets/result_cards_widget.dart';
import './widgets/suggestion_chips_widget.dart';
import './widgets/voice_input_widget.dart';

class AiTextToJewelry extends StatefulWidget {
  const AiTextToJewelry({Key? key}) : super(key: key);

  @override
  State<AiTextToJewelry> createState() => _AiTextToJewelryState();
}

class _AiTextToJewelryState extends State<AiTextToJewelry> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();
  bool _isProcessing = false;
  double _progress = 0.0;
  List<Map<String, dynamic>> _results = [];

  final int _maxCharacters = 500;
  final int _minCharacters = 10;

  // Mock jewelry design results
  final List<Map<String, dynamic>> _mockResults = [
    {
      'id': 1,
      'title': 'Anillo Solitario Clásico',
      'image':
          'https://images.unsplash.com/photo-1605100804763-247f67b3557e?w=400&h=300&fit=crop',
      'confidence': 92,
      'materials': ['Oro 18k', 'Diamante', 'Platino'],
      'description':
          'Elegante anillo solitario con diamante central de corte brillante',
      'estimatedWeight': '3.2g',
      'estimatedPrice': '\$2,450.00 MXN',
    },
    {
      'id': 2,
      'title': 'Anillo Vintage Ornamentado',
      'image':
          'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=400&h=300&fit=crop',
      'confidence': 87,
      'materials': ['Oro amarillo', 'Esmeralda', 'Diamantes'],
      'description':
          'Diseño vintage con detalles ornamentales y piedra central',
      'estimatedWeight': '4.1g',
      'estimatedPrice': '\$3,200.00 MXN',
    },
    {
      'id': 3,
      'title': 'Anillo Moderno Geométrico',
      'image':
          'https://images.unsplash.com/photo-1506630448388-4e683c67ddb0?w=400&h=300&fit=crop',
      'confidence': 89,
      'materials': ['Oro blanco', 'Zafiro', 'Diamantes'],
      'description': 'Diseño contemporáneo con líneas geométricas limpias',
      'estimatedWeight': '2.8g',
      'estimatedPrice': '\$2,890.00 MXN',
    },
  ];

  @override
  void initState() {
    super.initState();
    _textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _textController.dispose();
    _textFocusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  bool get _canGenerate =>
      _textController.text.trim().length >= _minCharacters && !_isProcessing;

  int get _remainingCharacters => _maxCharacters - _textController.text.length;

  void _onSuggestionChipTap(String suggestion) {
    _textController.text = suggestion;
    _textFocusNode.unfocus();
  }

  void _onVoiceResult(String result) {
    _textController.text = result;
    setState(() {});
  }

  Future<void> _generateDesign() async {
    if (!_canGenerate) return;

    setState(() {
      _isProcessing = true;
      _progress = 0.0;
      _results.clear();
    });

    _textFocusNode.unfocus();
    HapticFeedback.mediumImpact();

    // Simulate AI processing with progress updates
    for (int i = 0; i <= 100; i += 10) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (mounted) {
        setState(() {
          _progress = i / 100;
        });
      }
    }

    // Simulate processing time
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isProcessing = false;
        _progress = 0.0;
        _results = List.from(_mockResults);
      });

      HapticFeedback.lightImpact();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('¡${_results.length} diseños generados exitosamente!'),
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _onResultCardTap(Map<String, dynamic> result) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildResultDetailSheet(result),
    );
  }

  Widget _buildResultDetailSheet(Map<String, dynamic> result) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(4),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    result['title'] as String,
                    style:
                        AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 6.w,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  Container(
                    width: double.infinity,
                    height: 30.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withOpacity(0.1),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CustomImageWidget(
                        imageUrl: result['image'] as String,
                        width: double.infinity,
                        height: 30.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Details
                  _buildDetailRow(
                      'Descripción', result['description'] as String),
                  _buildDetailRow('Confianza IA', '${result['confidence']}%'),
                  _buildDetailRow(
                      'Peso estimado', result['estimatedWeight'] as String),
                  _buildDetailRow(
                      'Precio estimado', result['estimatedPrice'] as String),

                  SizedBox(height: 2.h),

                  Text(
                    'Materiales sugeridos',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(height: 1.h),

                  Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children:
                        (result['materials'] as List<String>).map((material) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.primary
                                .withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          material,
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),

          // Action buttons
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/3d-model-viewer');
                    },
                    child: Text('Ver en 3D'),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/stl-export-and-sharing');
                    },
                    child: Text('Exportar STL'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 30.w,
            child: Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onCancel() {
    if (_isProcessing) {
      setState(() {
        _isProcessing = false;
        _progress = 0.0;
      });
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          Column(
            children: [
              // Custom header
              CustomHeaderWidget(
                onCancel: _onCancel,
                progress: _progress,
              ),

              // Main content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 3.h),

                      // Title and subtitle
                      Text(
                        'Describe tu joya ideal',
                        style: AppTheme.lightTheme.textTheme.headlineMedium
                            ?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      SizedBox(height: 1.h),

                      Text(
                        'Usa palabras descriptivas para crear el diseño perfecto con IA',
                        style:
                            AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),

                      SizedBox(height: 4.h),

                      // Text input area
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.lightTheme.colorScheme.shadow,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Text field with voice input
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _textController,
                                    focusNode: _textFocusNode,
                                    maxLines: 6,
                                    maxLength: _maxCharacters,
                                    decoration: InputDecoration(
                                      hintText:
                                          'Describe tu joya ideal...\n\nEjemplo: "Un anillo de compromiso elegante con diamante central, banda delgada de oro blanco, estilo clásico y atemporal"',
                                      hintStyle: AppTheme
                                          .lightTheme.textTheme.bodyMedium
                                          ?.copyWith(
                                        color: AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant
                                            .withOpacity(0.7),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                      fillColor: Colors.transparent,
                                      contentPadding: EdgeInsets.all(4.w),
                                      counterText: '',
                                    ),
                                    style: AppTheme
                                        .lightTheme.textTheme.bodyLarge
                                        ?.copyWith(
                                      color: AppTheme
                                          .lightTheme.colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 2.h, right: 3.w),
                                  child: VoiceInputWidget(
                                    onVoiceResult: _onVoiceResult,
                                  ),
                                ),
                              ],
                            ),

                            // Character counter
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4.w, vertical: 2.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _textController.text.length >=
                                            _minCharacters
                                        ? '✓ Listo para generar'
                                        : 'Mínimo $_minCharacters caracteres',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: _textController.text.length >=
                                              _minCharacters
                                          ? AppTheme
                                              .lightTheme.colorScheme.primary
                                          : AppTheme.lightTheme.colorScheme
                                              .onSurfaceVariant,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '$_remainingCharacters caracteres restantes',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: _remainingCharacters < 50
                                          ? AppTheme
                                              .lightTheme.colorScheme.error
                                          : AppTheme.lightTheme.colorScheme
                                              .onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 3.h),

                      // Suggestion chips
                      Text(
                        'Sugerencias populares',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      SizedBox(height: 2.h),

                      SuggestionChipsWidget(
                        onChipTap: _onSuggestionChipTap,
                      ),

                      SizedBox(height: 4.h),

                      // Generate button
                      SizedBox(
                        width: double.infinity,
                        height: 6.h,
                        child: ElevatedButton(
                          onPressed: _canGenerate ? _generateDesign : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _canGenerate
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme.lightTheme.colorScheme.outline
                                    .withOpacity(0.3),
                            foregroundColor: _canGenerate
                                ? AppTheme.lightTheme.colorScheme.onPrimary
                                : AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                            elevation: _canGenerate ? 2 : 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: _isProcessing
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 5.w,
                                      height: 5.w,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          AppTheme
                                              .lightTheme.colorScheme.onPrimary,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 3.w),
                                    Text(
                                      'Generando diseño...',
                                      style: AppTheme
                                          .lightTheme.textTheme.titleMedium
                                          ?.copyWith(
                                        color: AppTheme
                                            .lightTheme.colorScheme.onPrimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'auto_fix_high',
                                      color: _canGenerate
                                          ? AppTheme
                                              .lightTheme.colorScheme.onPrimary
                                          : AppTheme.lightTheme.colorScheme
                                              .onSurfaceVariant,
                                      size: 5.w,
                                    ),
                                    SizedBox(width: 2.w),
                                    Text(
                                      'Generar con IA',
                                      style: AppTheme
                                          .lightTheme.textTheme.titleMedium
                                          ?.copyWith(
                                        color: _canGenerate
                                            ? AppTheme.lightTheme.colorScheme
                                                .onPrimary
                                            : AppTheme.lightTheme.colorScheme
                                                .onSurfaceVariant,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),

                      SizedBox(height: 4.h),

                      // Results section
                      if (_results.isNotEmpty) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Diseños generados',
                              style: AppTheme.lightTheme.textTheme.titleLarge
                                  ?.copyWith(
                                color:
                                    AppTheme.lightTheme.colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pushNamed(
                                  context, '/design-gallery'),
                              child: Text('Ver todos'),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        ResultCardsWidget(
                          results: _results,
                          onCardTap: _onResultCardTap,
                        ),
                        SizedBox(height: 4.h),
                      ],

                      // Quick actions
                      if (_results.isEmpty && !_isProcessing) ...[
                        Container(
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.primary
                                .withOpacity(0.05),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.primary
                                  .withOpacity(0.2),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Otras opciones de diseño',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.onSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildQuickActionButton(
                                      icon: 'mic',
                                      title: 'Voz a Joya',
                                      subtitle: 'Describe con tu voz',
                                      onTap: () => Navigator.pushNamed(
                                          context, '/voice-to-jewelry'),
                                    ),
                                  ),
                                  SizedBox(width: 3.w),
                                  Expanded(
                                    child: _buildQuickActionButton(
                                      icon: 'draw',
                                      title: 'Dibujar',
                                      subtitle: 'Crea con trazos',
                                      onTap: () => Navigator.pushNamed(
                                          context, '/sketch-and-draw-tool'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 4.h),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Processing overlay
          ProcessingOverlayWidget(
            isVisible: _isProcessing,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withOpacity(0.3),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: icon,
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 6.w,
                ),
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 0.5.h),
            Text(
              subtitle,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}