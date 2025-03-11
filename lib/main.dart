import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:walking/model/walking_player.dart';
import 'package:walking/model/walking_detector.dart';

WalkingPlayer? _audioHandler;

Future<void> main() async {
  _audioHandler ??= await AudioService.init<WalkingPlayer>(
    builder: () => WalkingPlayer(),
  );

  runApp(const MaterialApp(
    home: WalkingDetection(),
  ));
}

class WalkingDetection extends StatefulWidget {
  const WalkingDetection({super.key});

  @override
  createState() => _WalkingDetectionState();
}

class _WalkingDetectionState extends State<WalkingDetection> {
  bool walking = false;
  @override
  void initState() {
    super.initState();
    detectWalking(
      onWalking: () {
        _audioHandler?.play();
        print("Walking");
        setState(() => walking = true);
      },
      onStopWalking: () {
        _audioHandler?.pause();
        print("Not walking");
        setState(() => walking = false);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(title: const Text("<><")),
        body: Center(
          child: Text(
            walking ? "Your walking! :D" : "Your not walking >:c",
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
