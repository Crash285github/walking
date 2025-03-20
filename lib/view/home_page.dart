import 'package:flutter/material.dart';
import 'package:walking/service/walking_task_handler.dart';
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
        appBar: AppBar(
          title: const Text(
            "＜＞＜",
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
            ),
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
                    Spacer(flex: 4),
                    WalkingText(),
                    Spacer(),
                    SoundPicker(),
                    Spacer(flex: 6),
                    SpinningFish(),
                    Spacer(flex: 4),
                  ],
                ),
        ),
      );
}
