import 'package:jewelcraft_ai/presentation/preview/preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:jewelcraft_ai/services/ai_text_to_stl_service.dart';
import 'package:jewelcraft_ai/services/precio_calculator.dart';
import 'package:jewelcraft_ai/models/tipo_metal.dart';

class AiTextToJewelryScreen extends StatefulWidget {
  @override
  State<AiTextToJewelryScreen> createState() => _AiTextToJewelryScreenState();
}
import 'package:flutter/material.dart';
import 'package:jewelcraft_ai/models/tipo_metal.dart';
import 'package:jewelcraft_ai/presentation/preview/preview_screen.dart';
import 'package:jewelcraft_ai/services/ai_text_to_stl_service.dart';
import 'package:jewelcraft_ai/services/precio_calculator.dart';

class AiTextToJewelryScreen extends StatefulWidget {
  @override
  State<AiTextToJewelryScreen> createState() => _AiTextToJewelryScreenState();
}

class _AiTextToJewelryScreenState extends State<AiTextToJewelryScreen> {
  final _controller = TextEditingController();
  TipoMetal _selectedMetal = TipoMetal.oro18k;

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
            const SizedBox(height: 12),
            DropdownButton<TipoMetal>(
              value: _selectedMetal,
              items: TipoMetal.values.map((m) {
                return DropdownMenuItem(
                  value: m,
                  child: Text(m.name.toUpperCase()),
                );
              }).toList(),
              onChanged: (m) => setState(() => _selectedMetal = m!),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final stlFile = await AiTextToStlService.textToSTL(_controller.text);
                final price = await PrecioCalculator.calculatePrice(
                  1.0, // ← aquí iría el volumen real
                  _selectedMetal,
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PreviewScreen(
                      stlFile: stlFile.path,
                      priceEUR: price,
                      metal: _selectedMetal,
                    ),
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
