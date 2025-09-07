import 'package:jewelcraft_ai/presentation/preview/preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:jewelcraft_ai/services/ai_text_to_stl_service.dart';
import 'package:jewelcraft_ai/services/precio_calculator.dart';

class AiTextToJewelryScreen extends StatelessWidget {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Texto → Joya')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Describe tu joya'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final (stlFile, price) = await AiTextToStlService.textToJewelry(
                  _controller.text,
                  TipoMetal.oro18k,
                  PrecioCalculator.densidadOro18k,
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PreviewScreen(stlFile: stlFile, priceEUR: price, metal: TipoMetal.oro18k),
                  ),
                );
              },
              child: const Text('Generar joya'),
            ),
          ],
        ),
      ),
    );
  }
}
