import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:walking/local_storage.dart';
import 'package:walking/view/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.init();

  FlutterForegroundTask.initCommunicationPort();

  runApp(const WalkingDetectionApp());
}

class WalkingDetectionApp extends StatefulWidget {
  const WalkingDetectionApp({super.key});

  @override
  createState() => _WalkingDetectionAppState();
}

class _WalkingDetectionAppState extends State<WalkingDetectionApp> {
  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData.dark(),
        home: const HomePage(),
      );
}
