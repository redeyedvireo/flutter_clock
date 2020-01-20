import 'package:flutter/material.dart';

class ColorIncrement {
  double redDelta;
  double greenDelta;
  double blueDelta;

  double alphaDelta;

  ColorIncrement(
      {@required this.redDelta,
      @required this.greenDelta,
      @required this.blueDelta,
      @required this.alphaDelta});

  /// Computes a new color, using the class' increment values.
  Color newColor(Color color) {
    double newRed = color.red + redDelta;
    double newGreen = color.green + greenDelta;
    double newBlue = color.blue + blueDelta;
    double newAlpha = color.alpha + alphaDelta;

    return Color.fromARGB(
        newAlpha.round(), newRed.round(), newGreen.round(), newBlue.round());
  }
}
