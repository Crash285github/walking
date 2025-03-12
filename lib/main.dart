import 'dart:async';

import 'package:dchs_motion_sensors/dchs_motion_sensors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:walking/model/walking_detector.dart';

Future<void> startService() async {
  if (await FlutterForegroundTask.isRunningService) {
    await FlutterForegroundTask.stopService();
  }

  FlutterForegroundTask.init(
    androidNotificationOptions: AndroidNotificationOptions(
      channelId: "walking",
      channelName: "walking",
    ),
    iosNotificationOptions: const IOSNotificationOptions(),
    foregroundTaskOptions: ForegroundTaskOptions(
      eventAction: ForegroundTaskEventAction.nothing(),
      allowWakeLock: true,
      autoRunOnBoot: false,
    ),
  );

  await FlutterForegroundTask.startService(
    notificationTitle: "Walking Detection",
    notificationText: "Detecting your walking",
    callback: foregroundCallback,
  );
}

void main() {
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
  late final StreamSubscription<AccelerometerEvent> subcription;

  @override
  void initState() {
    super.initState();

    startService();

    subcription = detectWalking(
      onWalking: () => setState(() => walking = true),
      onStopWalking: () => setState(() => walking = false),
    );
  }

  @override
  void dispose() {
    subcription.cancel();
    super.dispose();
  }

  Future<void> startService() async {
    if (await FlutterForegroundTask.isRunningService) {
      print("Service already running");
      await FlutterForegroundTask.stopService();
    }

    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: "walking",
        channelName: "walking",
      ),
      iosNotificationOptions: const IOSNotificationOptions(),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.nothing(),
        allowWakeLock: true,
        autoRunOnBoot: false,
      ),
    );

    print("Starting service");
    await FlutterForegroundTask.startService(
      notificationTitle: "Walking Detection",
      notificationText: "Detecting your walking",
      callback: foregroundCallback,
    );
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
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
