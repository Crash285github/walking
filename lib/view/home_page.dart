import 'package:flutter/material.dart';
import 'package:walking/service/entry_points.dart';
import 'package:walking/view/drawer.dart';
import 'package:walking/view/light_switch.dart';
import 'package:walking/view/sound_picker.dart';
import 'package:walking/view/spinning_fish.dart';
import 'package:walking/view/walking_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loading = true;

  @override
  void initState() {
    super.initState();
    startWalkingForegroundService().whenComplete(
      () => setState(() => loading = false),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: const InfoDrawer(),
        backgroundColor: Theme.of(context).colorScheme.surfaceDim,
        appBar: AppBar(
          title: Image.asset(
            "assets/FISH.png",
            height: kToolbarHeight / 1.8,
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
        body: Center(
          child: loading
              ? const CircularProgressIndicator()
              : const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    WalkingText(),
                    Spacer(),
                    SoundPicker(),
                    LightSwitch(),
                    Spacer(flex: 3),
                    SpinningFish(),
                    Spacer(),
                  ],
                ),
        ),
      );
}
