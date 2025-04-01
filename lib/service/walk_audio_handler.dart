import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class WalkAudioHandler extends BaseAudioHandler {
  final _player = AudioPlayer(
    audioLoadConfiguration: const AudioLoadConfiguration(
      androidLoadControl: AndroidLoadControl(
        prioritizeTimeOverSizeThresholds: true,
      ),
    ),
  )..setLoopMode(LoopMode.one);

  @override
  Future<void> play() async {
    await sync();
    await _player.play();
  }

  @override
  Future<void> pause() async => await _player.pause();

  Future<void> dispose() async => await _player.dispose();

  Future<void> setAsset(final String asset) async {
    await _player.setAsset(asset);
    await sync();
  }

  Future<void> sync() async {
    final dateTime = DateTime.now();
    final duration = _player.duration;
    if (duration == null) return;

    final durationMs = duration.inMilliseconds;
    final millisSinceEpoch = dateTime.millisecondsSinceEpoch;
    final syncTime = millisSinceEpoch % durationMs;

    await _player.seek(Duration(milliseconds: syncTime));
  }

  static final WalkAudioHandler _instance = WalkAudioHandler._internal();
  factory WalkAudioHandler() => _instance;
  WalkAudioHandler._internal();
}
