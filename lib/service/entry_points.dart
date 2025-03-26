import 'dart:async';
import 'dart:math';

import 'package:dchs_motion_sensors/dchs_motion_sensors.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:walking/service/walking_task_handler.dart';

// MARK: fbCallback
@pragma('vm:entry-point')
void foregroundCallback() => FlutterForegroundTask.setTaskHandler(
      WalkingTaskHandler(),
    );

// MARK: start
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

// MARK: detectAccel
@pragma("vm:entry-point")
StreamSubscription<AccelerometerEvent> detectAcceleration({
  required Function? onAboveThreshold,
  double threshold = 2.7,
}) {
  motionSensors.accelerometerUpdateInterval =
      Duration.microsecondsPerSecond ~/ 60;

  return motionSensors.accelerometer.listen((final acceleration) {
    final x = acceleration.x;
    final y = acceleration.y;
    final z = acceleration.z;

    final magnitude = sqrt((x * x) + (y * y) + (z * z));
    final isAboveThreshold = (magnitude - 9.8).abs() > threshold;
    if (isAboveThreshold) {
      onAboveThreshold?.call();
    }
  });
}

// MARK: detectWalk
@pragma("vm:entry-point")
StreamSubscription<AccelerometerEvent> detectWalking({
  required Function? onWalking,
  required Function? onStopWalking,
  double threshold = 2.7,
}) {
  Timer? countdown;

  return detectAcceleration(
    onAboveThreshold: () {
      if (countdown == null) {
        onWalking?.call();
      }

      countdown?.cancel();
      countdown = Timer(const Duration(seconds: 1), () {
        onStopWalking?.call();

        countdown?.cancel();
        countdown = null;
      });
    },
    threshold: threshold,
  );
}
