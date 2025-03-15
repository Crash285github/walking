import 'package:flutter/material.dart';
import 'package:walking/local_storage.dart';
import 'package:walking/service/walk_audio_handler.dart';

class SoundPicker extends StatelessWidget {
  const SoundPicker({super.key});

  @override
  Widget build(BuildContext context) => DropdownMenu(
        onSelected: (final selected) {
          if (selected == null) return;

          LocalStorage.selectedAudio = selected;
          WalkAudioHandler().setAsset(selected);
        },
        initialSelection: LocalStorage.selectedAudio,
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
