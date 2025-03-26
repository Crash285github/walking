// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:dchs_motion_sensors/dchs_motion_sensors.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:light_sensor/light_sensor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walking/local_storage.dart';
import 'package:walking/service/entry_points.dart';
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
  Timer? walkingTimer;

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

    checkLight =
        prefs.getBool(LocalStorage.checkLightKey) ?? LocalStorage.checkLight;

    audioHandler = WalkAudioHandler();
    await audioHandler?.setAsset(asset);
    await AudioService.init<WalkAudioHandler>(builder: () => audioHandler!);

    subscription = detectAcceleration(
      onAboveThreshold: () async {
        if (checkLight) {
          final light = await LightSensor.luxStream().first;
          if (light > 1) {
            return;
          }
        }

        if (walkingTimer == null) {
          audioHandler?.play();
        }

        walkingTimer = Timer(const Duration(seconds: 1), () {
          audioHandler?.pause();

          walkingTimer?.cancel();
          walkingTimer = null;
        });
      },
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
