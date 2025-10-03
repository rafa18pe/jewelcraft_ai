import 'package:flutter/material.dart';
import 'package:jewelcraft_ai/presentation/ai_text_to_jewelry/ai_text_to_jewelry_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:jewelcraft_ai/core/api_keys.dart';

Future<void> _copyKeys() async {
  final dir = await getApplicationDocumentsDirectory();
  final targetFile = File('${dir.path}/keys.json');
  if (!await targetFile.exists()) {
    final downloads = Directory('/storage/emulated/0/Download');
    final sourceFile = File('${downloads.path}/keys.json');
    if (await sourceFile.exists()) {
      await targetFile.writeAsBytes(await sourceFile.readAsBytes());
    } else {
      // Si no está en Descargas, crea uno vacío para que no pete
      await targetFile.writeAsString('{"alltick":"PON_CLAVE","replicate":"PON_CLAVE","gemini":"PON_CLAVE","meshy":"PON_CLAVE"}');
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await _copyKeys(); // ← aquí copiamos las claves
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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _logText = 'Pulsa "Crear log" para ver qué pasa';

  Future<void> _createLog() async {
    final dir = await getApplicationDocumentsDirectory();
    final logFile = File('${dir.path}/jewelcraft_log.txt');
    try {
      logFile.writeAsStringSync('=== HOME PAGE ===\n');
      await _copyKeys();
      logFile.writeAsStringSync('keys.json copiado\n', mode: FileMode.append);
      final key = await ApiKeys.alltick;
      logFile.writeAsStringSync('Alltick key leída: ${key.substring(0, 5)}...\n', mode: FileMode.append);
      setState(() => _logText = 'Log creado sin errores');
    } catch (e) {
      logFile.writeAsStringSync('ERROR: $e\n', mode: FileMode.append);
      setState(() => _logText = 'ERROR: $e');
    }
  }

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
              onPressed: _createLog,
              child: const Text('Crear log'),
            ),
            const SizedBox(height: 12),
            Text(
              _logText,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AiTextToJewelryScreen())),
              child: const Text('Texto → Joya'),
            ),
          ],
        ),
      ),
    );
  }
}
