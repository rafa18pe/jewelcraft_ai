import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ApiKeys {
  static Map<String, dynamic>? _cache;

  static Future<Map<String, dynamic>> _load() async {
    if (_cache != null) return _cache!;
    final dir = await getExternalStorageDirectory(); // Android/data/.../files
    final file = File('${dir!.path}/keys.json');
    if (!await file.exists()) {
      throw Exception('keys.json no encontrado. Copia el archivo en ${file.path}');
    }
    final raw = await file.readAsString();
    _cache = jsonDecode(raw);
    return _cache!;
  }

  static Future<String> get replicate async => (await _load())['replicate'];
  static Future<String> get gemini      async => (await _load())['gemini'];
  static Future<String> get alltick     async => (await _load())['alltick'];
  static Future<String> get tripo3d     async => (await _load())['tripo3d'];
}
