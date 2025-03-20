import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:walking/local_storage.dart';

class SoundPicker extends StatefulWidget {
  const SoundPicker({super.key});

  @override
  State<SoundPicker> createState() => _SoundPickerState();
}

class _SoundPickerState extends State<SoundPicker> {
  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      onSelected: (final String? selected) async {
        if (selected == null) return;
        setState(() => LocalStorage.selected = selected);
        FlutterForegroundTask.sendDataToTask(LocalStorage.selectedAsset);
      },
      initialSelection: LocalStorage.selected,
      dropdownMenuEntries: [
        ...LocalStorage.sounds.keys.map(
          (final key) => DropdownMenuEntry<String>(
            value: key,
            label: key,
          ),
        )
      ],
    );
  }
}
