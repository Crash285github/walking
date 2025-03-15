import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const sounds = <String, String>{
    "Default": "assets/step.mp3",
  };

  static const _saveKey = "selectedAudio";

  static String _selectedAudio = "Default";
  static String get selectedAudio => _selectedAudio;
  static set selectedAudio(final String selected) {
    _selectedAudio = selected;

    SharedPreferences.getInstance().then(
      (final instance) => instance.setString(_saveKey, selected),
    );
  }

  static String get selectedAsset => sounds[_selectedAudio]!;

  static Future<void> init() async {
    final instance = await SharedPreferences.getInstance();
    _selectedAudio = instance.getString(_saveKey) ?? "Default";
  }
}
