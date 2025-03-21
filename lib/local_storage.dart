import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static late final SharedPreferences _prefs;
  static late final String appVersion;

  static final github =
      Uri.parse("https://github.com/Crash285github/walking/releases");

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    fishTaps = _prefs.getInt("fishTaps") ?? 0;
    selected = _prefs.getString(saveKey) ?? sounds.keys.first;

    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion = packageInfo.version;
  }

  static const saveKey = "selectedAudio";
  static const sounds = <String, String>{
    "step.mp3": "assets/sounds/step.mp3",
    "step_loop.mp3": "assets/sounds/step_loop.mp3",
    "CANS WALKING SFX.wav": "assets/sounds/cans.wav",
    "COAT WALKING SFX.wav": "assets/sounds/coat.wav",
    "crab walking.wav": "assets/sounds/crab.wav",
    "hey im walking here.wav": "assets/sounds/im_walking.wav",
    "SNOW WALKING.wav": "assets/sounds/snow.wav",
    "LOUD SNOW WALKING.wav": "assets/sounds/loud_snow.wav",
    "WATER WALKING.wav": "assets/sounds/water.wav",
    "LOUDER WATER WALKING.wav": "assets/sounds/loud_water.wav",
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
