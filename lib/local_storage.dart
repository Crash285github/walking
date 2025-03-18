class LocalStorage {
  static const sounds = <String, String>{
    "Default": "assets/step.mp3",
    "Loop": "assets/loop.mp3",
  };

  static const saveKey = "selectedAudio";

  static String defaultSelected = sounds["Default"]!;
}
