import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:walking/local_storage.dart';
import 'package:walking/service/walking_task_handler.dart';

class PocketSwitch extends StatefulWidget {
  const PocketSwitch({super.key});

  @override
  State<PocketSwitch> createState() => _PocketSwitchState();
}

class _PocketSwitchState extends State<PocketSwitch> {
  void _onTap(final bool value) {
    FlutterForegroundTask.sendDataToTask(
      WalkingTaskData(checkLight: value).toJson(),
    );

    setState(
      () => LocalStorage.onlyPocket = value,
    );
  }

  @override
  Widget build(BuildContext context) => Transform.translate(
        offset: const Offset(0.0, -4.0),
        child: Card(
          shape: BeveledRectangleBorder(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(16.0),
              bottomLeft: Radius.circular(16.0),
            ),
            side: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2.0,
            ),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 32.0),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => _onTap(!LocalStorage.onlyPocket),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Sound only in pocket ",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: "BabyDoll",
                    ),
                  ),
                  Switch(value: LocalStorage.onlyPocket, onChanged: _onTap),
                ],
              ),
            ),
          ),
        ),
      );
}
