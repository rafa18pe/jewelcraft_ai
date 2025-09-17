import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  final logFile = File('${dir.path}/jewelcraft_diag.txt');
  try {
    logFile.writeAsStringSync('=== INICIO MAIN ===\n');
    logFile.writeAsStringSync('dir: ${dir.path}\n', mode: FileMode.append);
    // Intentamos leer keys.json
    final keysFile = File('${dir.path}/keys.json');
    if (await keysFile.exists()) {
      final content = await keysFile.readAsString();
      logFile.writeAsStringSync('keys.json existe: ${content.length} chars\n', mode: FileMode.append);
    } else {
      logFile.writeAsStringSync('keys.json NO existe\n', mode: FileMode.append);
    }
    logFile.writeAsStringSync('=== FIN MAIN ===\n', mode: FileMode.append);
  } catch (e) {
    logFile.writeAsStringSync('ERROR MAIN: $e\n', mode: FileMode.append);
  }

  runApp(const DiagApp());
}

class DiagApp extends StatelessWidget {
  const DiagApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              final dir = await getApplicationDocumentsDirectory();
              final logFile = File('${dir.path}/jewelcraft_diag.txt');
              String text = 'No hay log';
              if (await logFile.exists()) {
                text = await logFile.readAsString();
              }
              // Compartir por WhatsApp
              Share.share('Diagnóstico:\n$text');
            },
            child: const Text('Compartir diagnóstico'),
          ),
        ),
      ),
    );
  }
}
