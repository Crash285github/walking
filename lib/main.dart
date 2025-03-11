import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:walking/model/walking_detector.dart';

Future<void> main() async {
  FlutterForegroundTask.initCommunicationPort();

  runApp(
    const MaterialApp(home: WalkingDetection()),
  );
}

class WalkingDetection extends StatefulWidget {
  const WalkingDetection({super.key});

  @override
  createState() => _WalkingDetectionState();
}

class _WalkingDetectionState extends State<WalkingDetection> {
  bool walking = false;
  @override
  void initState() {
    super.initState();

    detectWalking(
      onWalking: () => setState(() => walking = true),
      onStopWalking: () => setState(() => walking = false),
    );

    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: "walking",
        channelName: "walking",
      ),
      iosNotificationOptions: const IOSNotificationOptions(),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.nothing(),
        allowWakeLock: true,
        autoRunOnBoot: true,
      ),
    );
    FlutterForegroundTask.startService(
      notificationTitle: "Walking Detection",
      notificationText: "Detecting your walking",
      callback: foregroundCallback,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(title: const Text("<><")),
        body: Center(
          child: Text(
            walking ? "Your walking! :D" : "Your not walking >:c",
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
