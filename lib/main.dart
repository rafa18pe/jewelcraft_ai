import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

Future<String> _createLog() async {
  final dir = await getApplicationDocumentsDirectory();
  final logFile = File('${dir.path}/jewelcraft_diag.txt');
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
    return 'Log creado sin errores';
  } catch (e) {
    logFile.writeAsStringSync('ERROR: $e\n', mode: FileMode.append);
    return 'ERROR: $e';
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final msg = await _createLog();
  runApp(LogApp(msg: msg));
}

class LogApp extends StatelessWidget {
  final String msg;

  const LogApp({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                msg,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  final dir = await getApplicationDocumentsDirectory();
                  final logFile = File('${dir.path}/jewelcraft_diag.txt');
                  String text = 'No hay log';
                  if (await logFile.exists()) {
                    text = await logFile.readAsString();
                  }
                  // Mostrar en pantalla
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(text.length > 200 ? '${text.substring(0, 200)}...' : text)),
                  );
                },
                child: const Text('Ver log en pantalla'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
