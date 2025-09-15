import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ApiKeys {
  static Map<String, dynamic>? _cache;

  static Future<void> _load() async {
    if (_cache != null) return;
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/keys.json');
    final raw = await file.readAsString();
    _cache = jsonDecode(raw);
  }

  static Future<String> get alltick   async { await _load(); return _cache!['alltick']; }
  static Future<String> get replicate async { await _load(); return _cache!['replicate']; }
  static Future<String> get gemini    async { await _load(); return _cache!['gemini']; }
  static Future<String> get meshy     async { await _load(); return _cache!['meshy']; }
}
