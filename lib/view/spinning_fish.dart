import 'dart:async';

import 'package:dchs_motion_sensors/dchs_motion_sensors.dart';
import 'package:flutter/material.dart';
import 'package:gif/gif.dart';
import 'package:walking/local_storage.dart';
import 'package:walking/service/entry_points.dart';

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
            onTapDown: (final details) => setState(() => holding = true),
            onTapUp: (final details) => setState(() {
              holding = false;
              if (controller.isAnimating) {
                LocalStorage.fishTaps++;
              }
            }),
            onTapCancel: () => setState(() => holding = false),
            child: AnimatedScale(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              scale: holding ? 1.1 : 1,
              child: Gif(
                colorBlendMode: controller.isAnimating
                    ? BlendMode.dstIn
                    : BlendMode.srcATop,
                color: Colors.black.withAlpha(200),
                controller: controller,
                image: const AssetImage("assets/spinning_fish.gif"),
                fps: 360,
              ),
            ),
          ),
          Text(
            "＜${LocalStorage.fishTaps}＞＜",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ],
      );
}
