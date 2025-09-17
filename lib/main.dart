import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  final logFile = File('${dir.path}/jewelcraft_final.txt');
  try {
    logFile.writeAsStringSync('=== INICIO MAIN ===\n');
    // Intentamos leer env.json
    final envFile = File('${dir.path}/env.json');
    if (await envFile.exists()) {
      final content = await envFile.readAsString();
      logFile.writeAsStringSync('env.json existe: ${content.length} chars\n', mode: FileMode.append);
    } else {
      logFile.writeAsStringSync('env.json NO existe\n', mode: FileMode.append);
    }
    logFile.writeAsStringSync('=== FIN MAIN ===\n', mode: FileMode.append);
  } catch (e) {
    logFile.writeAsStringSync('ERROR: $e\n', mode: FileMode.append);
  }
  runApp(const BlankApp());
}

class BlankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            'Log creado. Lee jewelfinal_diag.txt',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
