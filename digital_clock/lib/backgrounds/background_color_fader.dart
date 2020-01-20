import 'package:flutter/material.dart';
import 'dart:math';

import '../peg_board.dart';
import '../elapsed_time.dart';
import '../color_fader.dart';

import 'background_manager.dart';

class BackgroundColorFader implements IBackground {
  PegBoard pegBoard;
  Random _random;
  ElapsedTime _elapsedTime;

  Color backgroundColor;

  ColorFader colorFader;

  int redDelta = 0;
  int blueDelta = 0;
  int greenDelta = 0;

  BackgroundColorFader({@required this.pegBoard}) {
    _random = Random(DateTime.now().second);

    _elapsedTime = ElapsedTime(targetMilliseconds: 60000);

    _randomizeColors();
  }

  _randomizeColors() {
    backgroundColor = pegBoard.randomColor(0.5);

    redDelta = _random.nextInt(12) * (_random.nextInt(7) > 3 ? 1 : -1);
    blueDelta = _random.nextInt(12) * (_random.nextInt(7) > 3 ? 1 : -1);
    greenDelta = _random.nextInt(12) * (_random.nextInt(7) > 3 ? 1 : -1);

    colorFader = ColorFader(
        startColor: backgroundColor,
        redDelta: redDelta,
        blueDelta: blueDelta,
        greenDelta: greenDelta);
  }

  void draw() {
    if (_elapsedTime.timesUp()) {
      _randomizeColors();
      _elapsedTime.reset();
    }

    int leftPegId = pegBoard.pegId(0, 0);
    int curPegId = leftPegId;

    for (int i = 0; i < PegBoard.pegHeight; i++) {
      for (int j = 0; j < PegBoard.pegWidth; j++) {
        pegBoard.getPeg(curPegId).pegColor = colorFader.color;
        curPegId++;
      }

      leftPegId += PegBoard.pegWidth;
      curPegId = leftPegId;
      colorFader.nextStep();
    }
  }
}
