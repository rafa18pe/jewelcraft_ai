import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

Future<void> _forceCopyEnv() async {
  final dir = await getApplicationDocumentsDirectory();
  final targetFile = File('${dir.path}/env.json');
  // SIEMPRE copiamos desde Descargas
  final downloads = Directory('/storage/emulated/0/Download');
  final sourceFile = File('${downloads.path}/env.json');
  if (await sourceFile.exists()) {
    await targetFile.writeAsBytes(await sourceFile.readAsBytes());
  } else {
    // Si no está en Descargas, creamos uno vacío para que no pete
    await targetFile.writeAsString('{"alltick":"PON_CLAVE","replicate":"PON_CLAVE","gemini":"PON_CLAVE","meshy":"PON_CLAVE"}');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _forceCopyEnv(); // ← aquí copiamos SIEMPRE desde Descargas
  runApp(DiagApp());
}

class DiagApp extends StatelessWidget {
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
              // Mostrar en pantalla
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(text.length > 200 ? '${text.substring(0, 200)}...' : text)),
              );
            },
            child: const Text('Ver log en pantalla'),
          ),
        ),
      ),
    );
  }
}
