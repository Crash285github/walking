import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static late final SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    fishTaps = _prefs.getInt("fishTaps") ?? 0;
    selected = _prefs.getString(saveKey) ?? sounds.keys.first;
  }

  static const saveKey = "selectedAudio";
  static const sounds = <String, String>{
    "Default": "assets/step.mp3",
    "Loop": "assets/loop.mp3",
  };

  static int _fishTaps = 0;
  static int get fishTaps => _fishTaps;
  static set fishTaps(final int value) {
    _fishTaps = value;
    _prefs.setInt("fishTaps", value);
  }

  static String _selected = sounds.keys.first;
  static String get selected => _selected;
  static set selected(final String value) {
    _selected = value;
    _prefs.setString(saveKey, value);
  }

  static String get selectedAsset => sounds[selected]!;
}
