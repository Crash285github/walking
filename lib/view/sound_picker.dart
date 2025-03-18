import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walking/local_storage.dart';
import 'package:walking/service/walking_task_handler.dart';

class SoundPicker extends StatefulWidget {
  const SoundPicker({super.key});

  @override
  State<SoundPicker> createState() => _SoundPickerState();
}

class _SoundPickerState extends State<SoundPicker> {
  String localSelected = LocalStorage.sounds["Default"]!;

  @override
  Widget build(BuildContext context) => DropdownMenu(
        onSelected: (final String? selected) async {
          if (selected == null) return;

          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString(LocalStorage.saveKey, selected);
          await prefs.reload();

          await resetWalkingForegroundService();

          setState(() => localSelected = selected);
        },
        initialSelection: localSelected,
        dropdownMenuEntries: [
          ...LocalStorage.sounds.keys.map(
            (final key) => DropdownMenuEntry<String>(
              value: LocalStorage.sounds[key]!,
              label: key,
            ),
          )
        ],
      );
}
