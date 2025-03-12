// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:dchs_motion_sensors/dchs_motion_sensors.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:walking/model/walking_player.dart';

@pragma('vm:entry-point')
void foregroundCallback() => FlutterForegroundTask.setTaskHandler(
      WalkingTaskHandler(),
    );

class WalkingTaskHandler extends TaskHandler {
  StreamSubscription<AccelerometerEvent>? subscription;

  WalkingPlayer? audioHandler;

  @override
  Future<void> onDestroy(DateTime timestamp) async {
    print("onDestroy");

    subscription?.cancel();
    audioHandler?.dispose();

    await FlutterForegroundTask.stopService();

    exit(0);
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    // nothing
  }

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    print("onStart");

    audioHandler ??= await AudioService.init<WalkingPlayer>(
      builder: () => WalkingPlayer(),
    );

    subscription = detectWalking(
      onWalking: () {
        audioHandler?.play();
        print("Walking");
      },
      onStopWalking: () {
        audioHandler?.pause();
        print("Not walking");
      },
    );
  }

  static final WalkingTaskHandler _instance = WalkingTaskHandler._internal();

  factory WalkingTaskHandler() {
    return _instance;
  }

  WalkingTaskHandler._internal();
}

@pragma("vm:entry-point")
StreamSubscription<AccelerometerEvent> detectWalking({
  required Function()? onWalking,
  required Function()? onStopWalking,
}) {
  bool walking = false;
  Timer? countdown;
  const threshold = 1.5;

  motionSensors.accelerometerUpdateInterval =
      Duration.microsecondsPerSecond ~/ 60;

  return motionSensors.accelerometer.listen((final accel) {
    final mag = sqrt(
      accel.x * accel.x + accel.y * accel.y + accel.z * accel.z,
    );

    walking = mag > 9.8 + threshold || mag < 9.8 - threshold;

    if (walking) {
      countdown?.cancel();

      if (countdown == null) {
        onWalking?.call();
      }

      countdown = Timer(
        const Duration(seconds: 1),
        () {
          countdown?.cancel();
          countdown = null;
          onStopWalking?.call();
        },
      );
    }
  });
}
