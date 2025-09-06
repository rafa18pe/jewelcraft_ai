import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:jewelcraft_ai/services/stl_obj_calculator.dart';
import 'package:jewelcraft_ai/services/precio_calculator.dart';

class AiTextToStlService {
  static final Map<String, dynamic> _keys = jsonDecode(
    File('/storage/emulated/0/Android/data/com.example.jewelcraft_ai/files/keys.json').readAsStringSync(),
  );

  static final String _geminiKey = _keys['gemini'] ?? '';
  static final String _tripoKey = _keys['tripo3d'] ?? '';
  static final String _alltickKey = _keys['alltick'] ?? '';

  /// Gemini → prompt técnico
  static Future<String> _generatePrompt(String userText) async {
    final dio = Dio();
    final response = await dio.post(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$_geminiKey',
      data: {
        "contents": [
          {
            "parts": [
              {"text": "Convert this jewelry idea into a short, precise English prompt for a 3D model generator. Output only the prompt.\n\nIdea: $userText"}
            ]
          }
        ]
      },
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
    return response.data['candidates'][0]['content']['parts'][0]['text'].trim();
  }

  /// Tripo3D → STL
  static Future<String> _tripoStlUrl(String prompt) async {
    final dio = Dio();
    final response = await dio.post(
      'https://api.tripo3d.ai/v2/openapi/task',
      data: {'prompt': prompt, 'type': 'text_to_model', 'format': 'stl'},
      options: Options(headers: {'Authorization': 'Bearer $_tripoKey'}),
    );
    final taskId = response.data['data']['task_id'];
    while (true) {
      final status = await dio.get(
        'https://api.tripo3d.ai/v2/openapi/task/$taskId',
        options: Options(headers: {'Authorization': 'Bearer $_tripoKey'}),
      );
      if (status.data['status'] == 'succeeded') {
        return status.data['data']['output'];
      }
      await Future.delayed(const Duration(seconds: 5));
    }
  }

  /// Descarga STL
  static Future<File> _downloadStl(String url) async {
    final dio = Dio();
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/model.stl');
    await dio.download(url, file.path);
    return file;
  }

  /// Precio con Alltick
  static Future<double> calculatePrice(File stlFile, TipoMetal metal, double densidad) async {
    final volumenCm3 = await StlObjCalculator.getVolumeCm3(stlFile);
    final pesoGramos = volumenCm3 * densidad;
    final dio = Dio();
    final response = await dio.get(
      'https://api.alltick.co/quote?symbol=${metal == TipoMetal.oro18k ? 'XAU' : 'XAG'}-EUR&api_token=$_alltickKey',
    );
    final precioEURPorGramo = double.parse(response.data['price'].toString()) / 31.1035;
    return pesoGramos * precioEURPorGramo;
  }

  /// Pipeline completo
  static Future<(File, double)> textToJewelry(String userText, TipoMetal metal, double densidad) async {
    final prompt = await _generatePrompt(userText);
    final stlUrl = await _tripoStlUrl(prompt);
    final stlFile = await _downloadStl(stlUrl);
    final price = await calculatePrice(stlFile, metal, densidad);
    return (stlFile, price);
  }
}
