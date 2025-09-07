import 'package:flutter/material.dart';
import 'package:jewelcraft_ai/presentation/ai_text_to_jewelry/ai_text_to_jewelry_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'JewelCraft AI',
              style: TextStyle(fontSize: 32, color: Colors.white),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AiTextToJewelryScreen(),
                  ),
                );
              },
              child: const Text('Texto → Joya'),
            ),
          ],
        ),
      ),
    );
  }
}
