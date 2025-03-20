import 'dart:async';

import 'package:dchs_motion_sensors/dchs_motion_sensors.dart';
import 'package:flutter/material.dart';
import 'package:walking/service/walking_task_handler.dart';

class SpinningFish extends StatefulWidget {
  const SpinningFish({super.key});

  @override
  State<SpinningFish> createState() => _SpinningFishState();
}

class _SpinningFishState extends State<SpinningFish> {
  late final StreamSubscription<AccelerometerEvent> subcription;
  bool enabled = false;

  @override
  void initState() {
    super.initState();
    subcription = detectWalking(
      onWalking: () => setState(() => enabled = true),
      onStopWalking: () => setState(() => enabled = false),
    );
  }

  @override
  void dispose() {
    subcription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Opacity(
        opacity: enabled ? 1 : 0.5,
        child: Image.asset(
          'assets/spinning_fish.gif',
          height: 200,
        ),
      );
}
