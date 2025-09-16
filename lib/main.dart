import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:jewelcraft_ai/presentation/ai_text_to_jewelry/ai_text_to_jewelry_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 // Logger interno: guarda en la carpeta privada de la app
final dir = await getApplicationDocumentsDirectory();
final logFile = File('${dir.path}/jewelcraft_log.txt');
try {
  logFile.writeAsStringSync('APP INICIADA\n');
  // Aquí puedes ir añadiendo más logs
} catch (e) {
  logFile.writeAsStringSync('ERROR EN MAIN: $e\n', mode: FileMode.append);
}
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

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
                    builder: (_) => AiTextToJewelryScreen(),
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
