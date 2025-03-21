import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:walking/local_storage.dart';
import 'package:walking/view/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterForegroundTask.initCommunicationPort();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await LocalStorage.init();

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
        theme: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.red,
            primary: Colors.pink[300]!,
            brightness: Brightness.dark,
          ),
          highlightColor: Colors.purple[300]!.withOpacity(0.5),
        ),
        home: const HomePage(),
      );
}
