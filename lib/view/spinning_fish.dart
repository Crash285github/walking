import 'dart:async';

import 'package:dchs_motion_sensors/dchs_motion_sensors.dart';
import 'package:flutter/material.dart';
import 'package:gif/gif.dart';
import 'package:walking/service/walking_task_handler.dart';

class SpinningFish extends StatefulWidget {
  const SpinningFish({super.key});

  @override
  State<SpinningFish> createState() => _SpinningFishState();
}

class _SpinningFishState extends State<SpinningFish>
    with TickerProviderStateMixin {
  late final StreamSubscription<AccelerometerEvent> subcription;
  late final GifController controller = GifController(vsync: this);

  @override
  void initState() {
    super.initState();
    subcription = detectWalking(
      onWalking: () => setState(() {
        controller.repeat();
      }),
      onStopWalking: () => setState(() {
        controller.stop();
      }),
    );
  }

  @override
  void dispose() {
    subcription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Opacity(
        opacity: controller.isAnimating ? 1 : 0.1,
        child: Gif(
          controller: controller,
          image: const AssetImage("assets/spinning_fish.gif"),
          fps: 360,
        ),
      );
}
