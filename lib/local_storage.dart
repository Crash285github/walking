import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static late final SharedPreferences _prefs;
  static late final String appVersion;

  static final github =
      Uri.parse("https://github.com/Crash285github/walking/releases");

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    fishTaps = _prefs.getInt(fishTapsKey) ?? 0;
    selected = _prefs.getString(assetKey) ?? sounds.keys.first;
    checkLight = _prefs.getBool(checkLightKey) ?? true;

    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion = packageInfo.version;
  }

  // MARK: Asset
  static const assetKey = "selectedAudio";
  static const sounds = <String, String>{
    "step.mp3": "assets/sounds/step.mp3",
    "step_quick.mp3": "assets/sounds/step_quick.mp3",
    "CANS WALKING SFX.wav": "assets/sounds/cans.wav",
    "COAT WALKING SFX.wav": "assets/sounds/coat.wav",
    "crab walking.wav": "assets/sounds/crab.wav",
    "hey im walking here.wav": "assets/sounds/im_walking.wav",
    "SNOW WALKING.wav": "assets/sounds/snow.wav",
    "LOUD SNOW WALKING.wav": "assets/sounds/loud_snow.wav",
    "WATER WALKING.wav": "assets/sounds/water.wav",
    "LOUDER WATER WALKING.wav": "assets/sounds/loud_water.wav",
  };

  static String _selected = sounds.keys.first;
  static String get selected => _selected;
  static set selected(final String value) {
    _selected = value;
    _prefs.setString(assetKey, value);
  }

  static String get selectedAsset => sounds[selected]!;

  // MARK: Fish Taps
  static const fishTapsKey = "fishTaps";
  static int _fishTaps = 0;
  static int get fishTaps => _fishTaps;
  static set fishTaps(final int value) {
    _fishTaps = value;
    _prefs.setInt(fishTapsKey, value);
  }

  // MARK: Light
  static const checkLightKey = "checkLight";
  static bool _checkLight = true;
  static bool get checkLight => _checkLight;
  static set checkLight(final bool value) {
    _checkLight = value;
    _prefs.setBool(checkLightKey, value);
  }
}
