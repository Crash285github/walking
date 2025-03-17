import 'dart:async';

import 'package:dchs_motion_sensors/dchs_motion_sensors.dart';
import 'package:flutter/material.dart';
import 'package:walking/service/walking_task_handler.dart';

class WalkingText extends StatefulWidget {
  const WalkingText({super.key});

  @override
  State<WalkingText> createState() => _WalkingTextState();
}

class _WalkingTextState extends State<WalkingText> {
  bool walking = false;

  late final StreamSubscription<AccelerometerEvent> subcription;

  @override
  void initState() {
    super.initState();
    subcription = detectWalking(
      onWalking: () => setState(() => walking = true),
      onStopWalking: () => setState(() => walking = false),
    );
  }

  @override
  void dispose() {
    subcription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Text(
        walking ? "Your walking! :D" : "Your not walking >:c",
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      );
}
