// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:dchs_motion_sensors/dchs_motion_sensors.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:light_sensor/light_sensor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walking/local_storage.dart';
import 'package:walking/service/walk_audio_handler.dart';

class WalkingTaskData {
  final String? asset;
  final bool? checkLight;

  const WalkingTaskData({this.asset, this.checkLight});

  Map<String, dynamic> toJson() => {
        "asset": asset,
        "checkLight": checkLight,
      };

  factory WalkingTaskData.fromJson(Map<String, dynamic> json) =>
      WalkingTaskData(
        asset: json["asset"] as String?,
        checkLight: json["checkLight"] as bool?,
      );
}

class WalkingTaskHandler extends TaskHandler {
  StreamSubscription<AccelerometerEvent>? subscription;
  WalkAudioHandler? audioHandler;
  bool checkLight = true;

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

    String? selected = prefs.getString(LocalStorage.assetKey);
    selected ??= LocalStorage.selected;

    final asset = LocalStorage.sounds[selected]!;

    audioHandler = WalkAudioHandler();
    await audioHandler?.setAsset(asset);
    await AudioService.init<WalkAudioHandler>(builder: () => audioHandler!);

    subscription = detectWalking(
      onWalking: () async {
        if (checkLight) {
          final light = await LightSensor.luxStream().first;
          if (light < 1) {
            audioHandler?.play();
          }
          return;
        }
        audioHandler?.play();
      },
      onStopWalking: () => audioHandler?.pause(),
    );
  }

  @override
  void onReceiveData(covariant Map<String, dynamic> data) {
    final parsed = WalkingTaskData.fromJson(data);

    print(parsed.asset);
    print(parsed.checkLight);

    if (parsed.asset != null) {
      audioHandler?.setAsset(parsed.asset!);
    }

    if (parsed.checkLight != null) {
      checkLight = parsed.checkLight!;
    }
  }

  // Singleton
  static final WalkingTaskHandler _instance = WalkingTaskHandler._internal();
  factory WalkingTaskHandler() => _instance;
  WalkingTaskHandler._internal();
}

@pragma("vm:entry-point")
StreamSubscription<AccelerometerEvent> detectWalking({
  required Function? onWalking,
  required Function? onStopWalking,
  double threshold = 2.7,
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
