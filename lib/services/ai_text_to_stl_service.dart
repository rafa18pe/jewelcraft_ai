import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class AiTextToStlService {
  /// Genera un archivo STL a partir del texto del usuario.
  /// Por ahora devuelve un archivo vacío de prueba.
  static Future<File> textToSTL(String userText) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/prueba.stl');
    await file.writeAsString('solid prueba\nendsolid prueba\n');
    return file;
  }
}
