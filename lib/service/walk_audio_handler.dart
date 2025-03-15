import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:walking/local_storage.dart';

class WalkAudioHandler extends BaseAudioHandler {
  final _player = AudioPlayer()..setLoopMode(LoopMode.one);

  @override
  Future<void> play() async => await _player.play();

  @override
  Future<void> pause() async => await _player.pause();

  Future<void> dispose() async => await _player.dispose();

  Future<void> setAsset(final String asset) async =>
      await _player.setAsset(asset);

  static final WalkAudioHandler _instance = WalkAudioHandler._internal();
  factory WalkAudioHandler() => _instance;
  WalkAudioHandler._internal() {
    _player.setAsset(LocalStorage.selectedAsset);
  }
}
