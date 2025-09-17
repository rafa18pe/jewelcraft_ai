import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<Map<String, dynamic>> _loadEnv() async {
  final dir = await getApplicationDocumentsDirectory();
  final envFile = File('${dir.path}/env.json');
  if (!await envFile.exists()) {
    // Copiar env.json desde assets
    final data = await rootBundle.loadString('assets/env.json');
    await envFile.writeAsString(data);
  }
  final raw = await envFile.readAsString();
  return jsonDecode(raw);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final env = await _loadEnv();
  runApp(DiagApp(env: env));
}

class DiagApp extends StatelessWidget {
  final Map<String, dynamic> env;

  const DiagApp({super.key, required this.env});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              final text = 'ENV cargado:\n'
                  'GEMINI: ${env['GEMINI_API_KEY']?.substring(0, 5)}...\n'
                  'ALLTICK: ${env['ALLTICK_API_KEY']?.substring(0, 5)}...\n'
                  'MESHY: ${env['MESHY_API_KEY']?.substring(0, 5)}...';
              Share.share(text);
            },
            child: const Text('Compartir ENV'),
          ),
        ),
      ),
    );
  }
}
