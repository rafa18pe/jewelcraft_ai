import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:jewelcraft_ai/core/api_keys.dart';

class MeshyService {
  static Future<String> textToSTL(String prompt) async {
    final dio = Dio();
    final response = await dio.post(
      'https://api.meshy.ai/v1/text-to-3d',
      data: {
        'prompt': prompt,
        'art_style': 'realistic',
        'target_polycount': 30000,
      },
      options: Options(headers: {'Authorization': 'Bearer ${await ApiKeys.meshy}'}),
    );
    // Meshy devuelve un task_id; aquí simplificamos y devolvemos URL del .stl
    return response.data['model_url'] as String;
  }
}
