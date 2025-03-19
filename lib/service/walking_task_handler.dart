// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:dchs_motion_sensors/dchs_motion_sensors.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walking/local_storage.dart';
import 'package:walking/service/walk_audio_handler.dart';

@pragma('vm:entry-point')
void foregroundCallback() => FlutterForegroundTask.setTaskHandler(
      WalkingTaskHandler(),
    );

Future<void> startWalkingForegroundService() async {
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

class WalkingTaskHandler extends TaskHandler {
  StreamSubscription<AccelerometerEvent>? subscription;
  WalkAudioHandler? audioHandler;

  @override
  Future<void> onDestroy(final DateTime timestamp) async {
    subscription?.cancel();
    audioHandler?.dispose();

    exit(0);
  }

  @override
  void onRepeatEvent(final DateTime timestamp) {
    // nothing
  }

  @override
  Future<void> onStart(
    final DateTime timestamp,
    final TaskStarter starter,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    final selected =
        prefs.getString(LocalStorage.saveKey) ?? LocalStorage.defaultSelected;

    audioHandler = WalkAudioHandler();

    await audioHandler?.setAsset(selected);
    await AudioService.init<WalkAudioHandler>(builder: () => audioHandler!);

    subscription = detectWalking(
      onWalking: () => audioHandler?.play(),
      onStopWalking: () => audioHandler?.pause(),
    );
  }

  @override
  void onReceiveData(covariant String data) => audioHandler?.setAsset(data);

  // Singleton
  static final WalkingTaskHandler _instance = WalkingTaskHandler._internal();
  factory WalkingTaskHandler() => _instance;
  WalkingTaskHandler._internal();
}

@pragma("vm:entry-point")
StreamSubscription<AccelerometerEvent> detectWalking({
  required Function? onWalking,
  required Function? onStopWalking,
  double threshold = 1.5,
}) {
  Timer? countdown;
  bool walking = false;

  motionSensors.accelerometerUpdateInterval =
      Duration.microsecondsPerSecond ~/ 60;

  return motionSensors.accelerometer.listen((final acceleration) {
    final x = acceleration.x;
    final y = acceleration.y;
    final z = acceleration.z;

    final magnitude = sqrt((x * x) + (y * y) + (z * z));
    walking = (magnitude - 9.8).abs() > threshold;

    if (walking) {
      if (countdown == null) {
        onWalking?.call();
      }

      countdown?.cancel();
      countdown = Timer(const Duration(seconds: 1), () {
        countdown?.cancel();
        countdown = null;
        onStopWalking?.call();
      });
    }
  });
}
