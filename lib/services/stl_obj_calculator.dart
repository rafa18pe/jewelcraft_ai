import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';

class StlObjCalculator {
  static Future<double> getVolumeCm3(File file) async {
    final bytes = await file.readAsBytes();
    final view = ByteData.sublistView(bytes);
    if (bytes.lengthInBytes < 84) throw Exception('STL demasiado pequeño');
    final triCount = view.getUint32(80, Endian.little);
    if (triCount == 0) return 0;
    int offset = 84;
    double volume = 0;
    for (int i = 0; i < triCount; i++) {
      if (offset + 50 > bytes.lengthInBytes) break;
      final p1 = _readVertex(view, offset + 12);
      final p2 = _readVertex(view, offset + 24);
      final p3 = _readVertex(view, offset + 36);
      volume += _tetrahedronVolume(p1, p2, p3);
      offset += 50;
    }
    return volume.abs();
  }

  static List<double> _readVertex(ByteData view, int offset) => [
        view.getFloat32(offset, Endian.little),
        view.getFloat32(offset + 4, Endian.little),
        view.getFloat32(offset + 8, Endian.little),
      ];

  static double _tetrahedronVolume(List<double> a, List<double> b, List<double> c) {
    final x = a[0] * b[1] * c[2] + b[0] * c[1] * a[2] + c[0] * a[1] * b[2];
    final y = a[0] * c[1] * b[2] + b[0] * a[1] * c[2] + c[0] * b[1] * a[2];
    return (x - y) / 6.0;
  }
}
