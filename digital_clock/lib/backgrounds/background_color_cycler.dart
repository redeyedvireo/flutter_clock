import 'package:flutter/material.dart';
import 'dart:math';

import 'package:digital_clock/peg_board.dart';
import '../color_cyler.dart';

import 'background_manager.dart';

class BackgroundColorCycler implements IBackground {
  PegBoard pegBoard;
  Random _random;

  ColorCycler colorCycler;
  double colorCycleScaleFactor = 20.0;

  BackgroundColorCycler({@required this.pegBoard}) {
    _random = Random(DateTime.now().second);

    colorCycler = ColorCycler(
        redMin: 100,
        redMax: 150,
        greenMin: 100,
        greenMax: 150,
        blueMin: 100,
        blueMax: 150,
        redDelta: (_random.nextDouble() * 10 + 5) / colorCycleScaleFactor,
        greenDelta: (_random.nextDouble() * 10 + 5) / colorCycleScaleFactor,
        blueDelta: (_random.nextDouble() * 10 + 5) / colorCycleScaleFactor,
        alpha: 200);
  }

  void draw() {
    pegBoard.fillPegArea(
        0, 0, PegBoard.pegWidth, PegBoard.pegHeight, colorCycler.color);
    colorCycler.next();
  }
}
