import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VoiceInputWidget extends StatefulWidget {
  final Function(String) onVoiceResult;

  const VoiceInputWidget({
    Key? key,
    required this.onVoiceResult,
  }) : super(key: key);

  @override
  State<VoiceInputWidget> createState() => _VoiceInputWidgetState();
}

class _VoiceInputWidgetState extends State<VoiceInputWidget> {
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  bool _isProcessing = false;
  String? _recordingPath;

  @override
  void dispose() {
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<bool> _requestMicrophonePermission() async {
    if (kIsWeb) return true;

    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  Future<void> _startRecording() async {
    if (!await _requestMicrophonePermission()) {
      _showErrorMessage('Permiso de micrófono requerido');
      return;
    }

    try {
      if (await _audioRecorder.hasPermission()) {
        setState(() {
          _isRecording = true;
        });

        if (kIsWeb) {
          await _audioRecorder.start(
            const RecordConfig(encoder: AudioEncoder.wav),
            path: 'recording.wav',
          );
        } else {
          final dir = await getTemporaryDirectory();
          _recordingPath =
              '${dir.path}/voice_input_${DateTime.now().millisecondsSinceEpoch}.m4a';
          await _audioRecorder.start(
            const RecordConfig(),
            path: _recordingPath!,
          );
        }
      }
    } catch (e) {
      setState(() {
        _isRecording = false;
      });
      _showErrorMessage('Error al iniciar grabación');
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();

      setState(() {
        _isRecording = false;
        _isProcessing = true;
      });

      // Simulate voice processing (in real app, this would call speech-to-text API)
      await Future.delayed(const Duration(seconds: 2));

      // Mock voice recognition result
      final mockResults = [
        'Quiero un anillo de oro con diamante pequeño',
        'Collar elegante para ocasión especial',
        'Aretes modernos de plata',
        'Pulsera delicada con perlas',
      ];

      final result =
          mockResults[DateTime.now().millisecond % mockResults.length];

      setState(() {
        _isProcessing = false;
      });

      widget.onVoiceResult(result);
    } catch (e) {
      setState(() {
        _isRecording = false;
        _isProcessing = false;
      });
      _showErrorMessage('Error al procesar audio');
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isProcessing
          ? null
          : (_isRecording ? _stopRecording : _startRecording),
      child: Container(
        width: 12.w,
        height: 6.h,
        decoration: BoxDecoration(
          color: _isRecording
              ? AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1)
              : AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _isRecording
                ? AppTheme.lightTheme.colorScheme.error
                : AppTheme.lightTheme.colorScheme.primary,
            width: 2,
          ),
        ),
        child: _isProcessing
            ? Center(
                child: SizedBox(
                  width: 4.w,
                  height: 4.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ),
              )
            : _isRecording
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'stop',
                        color: AppTheme.lightTheme.colorScheme.error,
                        size: 5.w,
                      ),
                      SizedBox(height: 0.5.h),
                      Container(
                        width: 8.w,
                        height: 0.5.h,
                        child: LinearProgressIndicator(
                          backgroundColor: AppTheme.lightTheme.colorScheme.error
                              .withValues(alpha: 0.3),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.lightTheme.colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: CustomIconWidget(
                      iconName: 'mic',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 6.w,
                    ),
                  ),
      ),
    );
  }
}
