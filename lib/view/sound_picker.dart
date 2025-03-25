import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:walking/local_storage.dart';
import 'package:walking/service/context_menu.dart';
import 'package:walking/service/walking_task_handler.dart';

class SoundPicker extends StatefulWidget {
  const SoundPicker({super.key});

  @override
  State<SoundPicker> createState() => _SoundPickerState();
}

class _SoundPickerState extends State<SoundPicker> {
  Future<void> _onTapUp(final Offset offset) async {
    final selected = await showContextMenu<String?>(
      context: context,
      offset: offset,
      items: [
        ...LocalStorage.sounds.keys.map(
          (final key) => PopupMenuItem<String?>(
            value: key,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                key,
                style: TextStyle(
                  fontSize: 20.0,
                  fontStyle: key == LocalStorage.selected
                      ? FontStyle.italic
                      : FontStyle.normal,
                  color: key == LocalStorage.selected
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
              ),
            ),
          ),
        ),
      ],
    );

    if (selected == null) return;
    if (selected == LocalStorage.selected) return;

    setState(() => LocalStorage.selected = selected);
    FlutterForegroundTask.sendDataToTask(
      WalkingTaskData(asset: LocalStorage.selectedAsset).toJson(),
    );
  }

  @override
  Widget build(BuildContext context) => Card(
        shape: BeveledRectangleBorder(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16.0),
            bottomRight: Radius.circular(16.0),
          ),
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2.0,
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 32.0),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTapUp: (final details) => _onTapUp(details.globalPosition),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Selected walking sound:",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(),
                SizedBox(
                  height: 32.0,
                  child: FittedBox(
                    alignment: Alignment.centerRight,
                    child: Text(
                      LocalStorage.selected,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 24.0,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
