import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walking/local_storage.dart';

class SoundPicker extends StatefulWidget {
  const SoundPicker({super.key});

  @override
  State<SoundPicker> createState() => _SoundPickerState();
}

class _SoundPickerState extends State<SoundPicker> {
  String localSelected = LocalStorage.sounds["Default"]!;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadSelectedSound();
  }

  Future<void> _loadSelectedSound() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();

    final String? selected = prefs.getString(LocalStorage.saveKey);
    if (selected != null) {
      localSelected = selected;
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return DropdownMenu(
      onSelected: (final String? selected) async {
        if (selected == null) return;

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(LocalStorage.saveKey, selected);
        await prefs.reload();

        FlutterForegroundTask.sendDataToTask(selected);

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
}
