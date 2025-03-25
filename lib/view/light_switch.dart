import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:walking/local_storage.dart';
import 'package:walking/service/walking_task_handler.dart';

class LightSwitch extends StatefulWidget {
  const LightSwitch({super.key});

  @override
  State<LightSwitch> createState() => _LightSwitchState();
}

class _LightSwitchState extends State<LightSwitch> {
  void _onTap(final bool value) {
    setState(
      () => LocalStorage.checkLight = value,
    );

    FlutterForegroundTask.sendDataToTask(
      WalkingTaskData(checkLight: value).toJson(),
    );
  }

  @override
  Widget build(BuildContext context) => Transform.translate(
        offset: const Offset(0.0, -2.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Material(
            type: MaterialType.transparency,
            clipBehavior: Clip.antiAlias,
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
            child: InkWell(
              onTap: () => _onTap(!LocalStorage.checkLight),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Sound only in pocket ",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Switch(value: LocalStorage.checkLight, onChanged: _onTap),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
