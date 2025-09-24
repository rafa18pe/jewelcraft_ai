import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/language_selector_widget.dart';
import './widgets/noise_indicator_widget.dart';
import './widgets/processing_status_widget.dart';
import './widgets/recording_button_widget.dart';
import './widgets/recording_controls_widget.dart';
import './widgets/recording_timer_widget.dart';
import './widgets/sound_wave_visualizer_widget.dart';
import './widgets/transcription_display_widget.dart';

class VoiceToJewelry extends StatefulWidget {
  const VoiceToJewelry({Key? key}) : super(key: key);

  @override
  State<VoiceToJewelry> createState() => _VoiceToJewelryState();
}

class _VoiceToJewelryState extends State<VoiceToJewelry>
    with TickerProviderStateMixin {
  // Recording state
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  bool _hasRecording = false;
  bool _isPlaying = false;
  bool _isProcessing = false;
  String? _recordingPath;

  // Timer and duration
  Timer? _recordingTimer;
  Duration _recordingDuration = Duration.zero;
  final Duration _maxRecordingDuration = const Duration(seconds: 60);

  // Audio visualization
  List<double> _audioLevels = [];
  Timer? _audioLevelTimer;
  final Random _random = Random();

  // Transcription
  String _transcription = '';
  String _selectedLanguage = 'es-MX';

  // Noise detection
  double _noiseLevel = 0.0;
  bool _showNoiseWarning = false;

  // Processing status
  String _processingStatus = '';
  double? _processingProgress;

  // Mock jewelry results data
  final List<Map<String, dynamic>> _mockJewelryResults = [
    {
      "id": 1,
      "name": "Anillo de Compromiso Clásico",
      "description":
          "Elegante anillo de oro blanco de 18k con diamante solitario de 1 quilate, diseño clásico y atemporal",
      "material": "Oro blanco 18k",
      "gemstone": "Diamante 1ct",
      "price": "\$45,000 MXN",
      "weight": "3.2g",
      "image":
          "https://images.unsplash.com/photo-1605100804763-247f67b3557e?w=400&h=400&fit=crop",
      "confidence": 0.95,
    },
    {
      "id": 2,
      "name": "Collar de Perlas Elegante",
      "description":
          "Hermoso collar de perlas cultivadas con cierre de oro amarillo, perfecto para ocasiones especiales",
      "material": "Oro amarillo 14k",
      "gemstone": "Perlas cultivadas",
      "price": "\$28,500 MXN",
      "weight": "15.8g",
      "image":
          "https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=400&h=400&fit=crop",
      "confidence": 0.88,
    },
    {
      "id": 3,
      "name": "Aretes de Esmeralda",
      "description":
          "Sofisticados aretes con esmeraldas naturales y diamantes en montura de platino",
      "material": "Platino",
      "gemstone": "Esmeraldas y diamantes",
      "price": "\$67,200 MXN",
      "weight": "4.7g",
      "image":
          "https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?w=400&h=400&fit=crop",
      "confidence": 0.92,
    },
  ];

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  @override
  void dispose() {
    _recordingTimer?.cancel();
    _audioLevelTimer?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _requestPermissions() async {
    if (kIsWeb) return;

    final microphoneStatus = await Permission.microphone.request();
    if (!microphoneStatus.isGranted) {
      _showErrorSnackBar('Se requiere permiso de micrófono para grabar audio');
    }
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        await _audioRecorder.start(
          const RecordConfig(encoder: AudioEncoder.aacLc),
          path: 'recording.aac',
        );

        setState(() {
          _isRecording = true;
          _recordingDuration = Duration.zero;
          _audioLevels.clear();
          _showNoiseWarning = false;
        });

        _startRecordingTimer();
        _startAudioLevelMonitoring();
      } else {
        _showErrorSnackBar('Permiso de micrófono denegado');
      }
    } catch (e) {
      _showErrorSnackBar('Error al iniciar grabación: ${e.toString()}');
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();

      setState(() {
        _isRecording = false;
        _hasRecording = path != null;
        _recordingPath = path;
      });

      _recordingTimer?.cancel();
      _audioLevelTimer?.cancel();

      if (path != null) {
        await _processRecording();
      }
    } catch (e) {
      _showErrorSnackBar('Error al detener grabación: ${e.toString()}');
    }
  }

  void _startRecordingTimer() {
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordingDuration = Duration(seconds: timer.tick);
      });

      if (_recordingDuration >= _maxRecordingDuration) {
        _stopRecording();
      }
    });
  }

  void _startAudioLevelMonitoring() {
    _audioLevelTimer =
        Timer.periodic(const Duration(milliseconds: 100), (timer) {
      // Simulate audio levels and noise detection
      final level = _random.nextDouble();
      final noise = _random.nextDouble();

      setState(() {
        _audioLevels.add(level);
        if (_audioLevels.length > 50) {
          _audioLevels.removeAt(0);
        }

        _noiseLevel = noise;
        _showNoiseWarning = noise > 0.7;
      });
    });
  }

  Future<void> _processRecording() async {
    setState(() {
      _isProcessing = true;
      _processingStatus = 'Analizando audio...';
      _processingProgress = 0.0;
    });

    // Simulate speech recognition processing
    final steps = [
      'Analizando audio...',
      'Reconociendo voz...',
      'Procesando lenguaje natural...',
      'Generando descripción de joya...',
      'Finalizando...',
    ];

    for (int i = 0; i < steps.length; i++) {
      await Future.delayed(const Duration(milliseconds: 800));
      setState(() {
        _processingStatus = steps[i];
        _processingProgress = (i + 1) / steps.length;
      });
    }

    // Simulate transcription result
    final mockTranscriptions = [
      'Quiero un anillo de compromiso elegante con un diamante grande y brillante, de oro blanco, que sea clásico y atemporal',
      'Me gustaría un collar de perlas naturales con cierre de oro, algo elegante para usar en ocasiones especiales',
      'Busco unos aretes con esmeraldas y diamantes, que sean sofisticados y llamativos, preferiblemente en platino',
    ];

    setState(() {
      _transcription =
          mockTranscriptions[_random.nextInt(mockTranscriptions.length)];
      _isProcessing = false;
      _processingStatus = '';
      _processingProgress = null;
    });
  }

  void _playPauseRecording() {
    setState(() {
      _isPlaying = !_isPlaying;
    });

    // Simulate playback
    if (_isPlaying) {
      Timer(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _isPlaying = false;
          });
        }
      });
    }
  }

  void _clearRecording() {
    setState(() {
      _hasRecording = false;
      _isPlaying = false;
      _recordingPath = null;
      _transcription = '';
      _recordingDuration = Duration.zero;
      _audioLevels.clear();
    });
  }

  void _onLanguageChanged(String language) {
    setState(() {
      _selectedLanguage = language;
    });
  }

  void _onTranscriptionChanged(String text) {
    setState(() {
      _transcription = text;
    });
  }

  void _generateJewelryDesigns() {
    if (_transcription.trim().isEmpty) {
      _showErrorSnackBar('Por favor, proporciona una descripción de la joya');
      return;
    }

    Navigator.pushNamed(context, '/ai-text-to-jewelry');
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Voz a Joya',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 4.w),
            child: LanguageSelectorWidget(
              selectedLanguage: _selectedLanguage,
              onLanguageChanged: _onLanguageChanged,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Column(
            children: [
              SizedBox(height: 3.h),

              // Instructions
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primaryContainer
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'info',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        'Mantén presionado el botón para grabar tu descripción de joya (máximo 60 segundos)',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 4.h),

              // Sound wave visualizer
              SoundWaveVisualizerWidget(
                isRecording: _isRecording,
                audioLevels: _audioLevels,
              ),

              SizedBox(height: 3.h),

              // Recording button
              RecordingButtonWidget(
                isRecording: _isRecording,
                isProcessing: _isProcessing,
                onStartRecording: _startRecording,
                onStopRecording: _stopRecording,
              ),

              SizedBox(height: 2.h),

              // Recording timer
              RecordingTimerWidget(
                recordingDuration: _recordingDuration,
                maxDuration: _maxRecordingDuration,
                isRecording: _isRecording,
              ),

              SizedBox(height: 2.h),

              // Noise indicator
              NoiseIndicatorWidget(
                noiseLevel: _noiseLevel,
                showWarning: _showNoiseWarning && _isRecording,
              ),

              // Processing status
              ProcessingStatusWidget(
                isProcessing: _isProcessing,
                statusMessage: _processingStatus,
                progress: _processingProgress,
              ),

              SizedBox(height: 2.h),

              // Recording controls
              RecordingControlsWidget(
                isRecording: _isRecording,
                hasRecording: _hasRecording,
                isPlaying: _isPlaying,
                onPlayPause: _playPauseRecording,
                onClear: _clearRecording,
              ),

              SizedBox(height: 3.h),

              // Transcription display
              TranscriptionDisplayWidget(
                transcription: _transcription,
                isEditable: !_isRecording && !_isProcessing,
                onTranscriptionChanged: _onTranscriptionChanged,
              ),

              SizedBox(height: 4.h),

              // Generate button
              if (_transcription.isNotEmpty && !_isProcessing)
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _generateJewelryDesigns,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'auto_awesome',
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Generar Diseños de Joya',
                          style: AppTheme.lightTheme.textTheme.labelLarge
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              SizedBox(height: 4.h),

              // Quick navigation
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.lightTheme.colorScheme.shadow
                          .withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Otras opciones',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Expanded(
                          child: _buildQuickActionButton(
                            icon: 'text_fields',
                            label: 'Texto a Joya',
                            onTap: () => Navigator.pushNamed(
                                context, '/ai-text-to-jewelry'),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: _buildQuickActionButton(
                            icon: 'brush',
                            label: 'Dibujar',
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
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primaryContainer
              .withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}