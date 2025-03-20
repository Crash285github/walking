import 'dart:async';

import 'package:dchs_motion_sensors/dchs_motion_sensors.dart';
import 'package:flutter/material.dart';
import 'package:gif/gif.dart';
import 'package:walking/local_storage.dart';
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

  bool holding = false;

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
  Widget build(BuildContext context) => Column(
        children: [
          GestureDetector(
            onTapDown: (details) => setState(() => holding = true),
            onTapUp: (details) => setState(() {
              holding = false;
              LocalStorage.fishTaps++;
            }),
            onTapCancel: () => setState(() => holding = false),
            child: Opacity(
              opacity: controller.isAnimating ? 1 : 0.3,
              child: AnimatedScale(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                scale: holding ? 1.1 : 1,
                child: Gif(
                  controller: controller,
                  image: const AssetImage("assets/spinning_fish.gif"),
                  fps: 360,
                ),
              ),
            ),
          ),
          Text(
            LocalStorage.fishTaps.toString(),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ],
      );
}
