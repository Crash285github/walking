import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class WalkingPlayer extends BaseAudioHandler {
  final _player = AudioPlayer()
    ..setLoopMode(LoopMode.one)
    ..setAsset('assets/step.mp3');

  @override
  Future<void> play() async => await _player.play();

  @override
  Future<void> pause() async => await _player.pause();

  Future<void> setAsset(final String asset) async =>
      await _player.setAsset(asset);

  static final WalkingPlayer _instance = WalkingPlayer._internal();
  factory WalkingPlayer() => _instance;
  WalkingPlayer._internal();
}
