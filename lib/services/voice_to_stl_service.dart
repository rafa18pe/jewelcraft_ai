import 'dart:io';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:jewelcraft_ai/services/ai_text_to_stl_service.dart';

class VoiceToStlService {
  static final stt.SpeechToText _speech = stt.SpeechToText();

  static Future<String> listen() async {
    bool available = await _speech.initialize();
    if (!available) throw Exception('Speech no disponible');
    String result = '';
    await _speech.listen(
      onResult: (val) => result = val.recognizedWords,
      localeId: 'es_ES',
    );
    await Future.delayed(const Duration(seconds: 5));
    await _speech.stop();
    return result.trim();
  }

  static Future<(File, double)> voiceToJewelry(TipoMetal metal, double densidad) async {
    final text = await listen();
    if (text.isEmpty) throw Exception('No se capturó voz');
    return AiTextToStlService.textToJewelry(text, metal, densidad);
  }
}
