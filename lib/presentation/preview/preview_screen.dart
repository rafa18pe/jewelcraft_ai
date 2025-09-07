import 'package:flutter/material.dart';
import 'package:jewelcraft_ai/models/tipo_metal.dart';

class PreviewScreen extends StatelessWidget {
  final String stlFile;
  final double priceEUR;
  final TipoMetal metal;

  const PreviewScreen({
    required this.stlFile,
    required this.priceEUR,
    required this.metal,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Previsualización')),
      body: Center(
        child: Text('STL: $stlFile\nPrecio: $priceEUR €\nMetal: $metal'),
      ),
    );
  }
}
