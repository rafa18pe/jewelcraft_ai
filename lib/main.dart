import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';

import 'core/app_export.dart';
import 'widgets/custom_error_widget.dart';

Future<File> _getLogFile() async {
  final dir = await getApplicationDocumentsDirectory();
  return File('${dir.path}/app_log.txt');
}

Future<void> _appendLog(String message) async {
  try {
    final file = await _getLogFile();
    await file.writeAsString('[${DateTime.now().toIso8601String()}] $message\n', mode: FileMode.append, flush: true);
  } catch (_) {}
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) async {
    Zone.current.handleUncaughtError(details.exception, details.stack ?? StackTrace.current);
  };

  await _appendLog('App starting');

  runZonedGuarded<Future<void>>(() async {
    runApp(const JewelcraftApp());
  }, (Object error, StackTrace stack) async {
    await _appendLog('Uncaught error: $error\n$stack');
  });
}

class JewelcraftApp extends StatelessWidget {
  const JewelcraftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        ErrorWidget.builder = (FlutterErrorDetails details) {
          _appendLog('Flutter error widget: ${details.exceptionAsString()}');
          return const CustomErrorWidget();
        };

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Jewelcraft AI',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          initialRoute: AppRoutes.initial,
          routes: AppRoutes.routes,
        );
      },
    );
  }
}
