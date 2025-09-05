import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:jewelcraft_ai/services/stl_obj_calculator.dart';
import 'package:jewelcraft_ai/services/precio_calculator.dart';

class SketchToStlService {
  static final String _replicateKey = '';

  static Future<Uint8List> _enhanceImage(Uint8List rawPng) async {
    final dio = Dio();
    final upload = await dio.post(
      'https://api.replicate.com/v1/files',
      data: FormData.fromMap({'content': MultipartFile.fromBytes(rawPng, filename: 'sketch.png')}),
      options: Options(headers: {'Authorization': 'Token $_replicateKey'}),
    );
    final imageUrl = upload.data['url'];
    final response = await dio.post(
      'https://api.replicate.com/v1/predictions',
      data: {"version": "e3b0c44298fc1c149afbf4c8996fb924", "input": {"image": imageUrl, "scale": 4}},
      options: Options(headers: {'Authorization': 'Token $_replicateKey'}),
    );
    final predictionId = response.data['id'];
    while (true) {
      final status = await dio.get('https://api.replicate.com/v1/predictions/$predictionId', options: Options(headers: {'Authorization': 'Token $_replicateKey'}));
      if (status.data['status'] == 'succeeded') return status.data['output'];
      await Future.delayed(const Duration(seconds: 3));
    }
  }

  static Future<String> _imageToStlUrl(Uint8List enhancedPng) async {
    final dio = Dio();
    final upload = await dio.post('https://api.replicate.com/v1/files', data: FormData.fromMap({'content': MultipartFile.fromBytes(enhancedPng, filename: 'enhanced.png')}), options: Options(headers: {'Authorization': 'Token $_replicateKey'}));
    final imageUrl = upload.data['url'];
    final response = await dio.post('https://api.replicate.com/v1/predictions', data: {"version": "e3b0c44298fc1c149afbf4c8996fb924", "input": {"image": imageUrl, "format": "stl"}}, options: Options(headers: {'Authorization': 'Token $_replicateKey'}));
    final predictionId = response.data['id'];
    while (true) {
      final status = await dio.get('https://api.replicate.com/v1/predictions/$predictionId', options: Options(headers: {'Authorization': 'Token $_replicateKey'}));
      if (status.data['status'] == 'succeeded') return status.data['output'];
      await Future.delayed(const Duration(seconds: 5));
    }
  }

  static Future<File> _downloadStl(String url) async {
    final dio = Dio();
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/sketch_model.stl');
    await dio.download(url, file.path);
    return file;
  }

  static Future<(File, double)> sketchToJewelry(Uint8List rawPng, TipoMetal metal, double densidad) async {
    final enhanced = await _enhanceImage(rawPng);
    final stlUrl = await _imageToStlUrl(enhanced);
    final stlFile = await _downloadStl(stlUrl);
    final price = await PrecioCalculator.calculatePrice(volumenCm3: await StlObjCalculator.getVolumeCm3(stlFile), tipo: metal);
    return (stlFile, price);
  }
}
