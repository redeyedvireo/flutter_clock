import 'package:flutter/material.dart';
import 'dart:math';

import 'package:digital_clock/peg_board.dart';
import '../color_fader.dart';

import 'background_manager.dart';

class BackgroundColorFader implements IBackground {
  PegBoard pegBoard;
  Random _random;

  int redDelta = 0;
  int blueDelta = 0;
  int greenDelta = 0;


  BackgroundColorFader({@required this.pegBoard}) {
    _random = Random(DateTime.now().second);

    redDelta = _random.nextInt(12) * (_random.nextInt(7) > 3 ? 1 : -1);
    blueDelta = _random.nextInt(12) * (_random.nextInt(7) > 3 ? 1 : -1);
    greenDelta = _random.nextInt(12) * (_random.nextInt(7) > 3 ? 1 : -1);
  }

  void draw() {
    final colorFader = ColorFader(startColor: pegBoard.globalBackgroundColor, redDelta: redDelta, blueDelta: blueDelta, greenDelta: greenDelta);

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