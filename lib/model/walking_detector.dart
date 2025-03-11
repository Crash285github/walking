import 'dart:async';
import 'dart:math';

import 'package:dchs_motion_sensors/dchs_motion_sensors.dart';

@pragma("vm:entry-point")
void detectWalking({
  required Function()? onWalking,
  required Function()? onStopWalking,
}) {
  bool walking = false;
  Timer? countdown;
  const threshold = 1.5;

  motionSensors.accelerometerUpdateInterval =
      Duration.microsecondsPerSecond ~/ 60;

  motionSensors.accelerometer.listen((final accel) {
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
