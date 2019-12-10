import 'package:flutter/material.dart';
import 'dart:math';

class ColorFader {
  Color color;

  int redDelta = 0;
  int greenDelta = 0;
  int blueDelta = 0;
  int alphaDelta = 0;

  ColorFader({@required this.color,
              this.redDelta = 0,
              this.greenDelta = 0,
              this.blueDelta = 0,
              this.alphaDelta = 0});

  Color nextStep() {
    final nextRed = min(max(color.red + redDelta, 0), 255);
    final nextGreen = min(max(color.green + greenDelta, 0), 255);
    final nextBlue = min(max(color.blue + blueDelta, 0), 255);
    final nextAlpha = min(max(color.alpha + alphaDelta, 0), 255);

    color = Color.fromARGB(nextAlpha, nextRed, nextGreen, nextBlue);
    return color;
  }
}