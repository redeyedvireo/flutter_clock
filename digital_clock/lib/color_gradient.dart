import 'package:flutter/material.dart';
import 'dart:math';

import 'color_increment.dart';

class ColorGradient {
  List<Color> colorStops;       // Colors at each gradient "stop"
  int stepsPerStop;             // Number of steps to get from one stop to the next

  int _currentPosition = 0;     // Position within a stop
  int _currentStop = 0;
  Color _currentColor = Colors.black;

  List<ColorIncrement> _increments = [];

  ColorGradient({@required this.colorStops, @required this.stepsPerStop}) {
    _build();
  }

  void _build() {
    int numStops = colorStops.length;

    for (int stop = 0; stop < numStops - 1; stop++) {
      Color startColor = colorStops[stop];
      Color endColor = colorStops[stop + 1];

      final colorIncrement = _computeIncrement(startColor, endColor);
      _increments.add(colorIncrement);
    }

    // Add increment from last color to first color
    final colorIncrement = _computeIncrement(colorStops[colorStops.length - 1], colorStops[0]);
    _increments.add(colorIncrement);
  }

  ColorIncrement _computeIncrement(Color startColor, Color endColor) {
    double redDelta = _computeDelta(startColor.red, endColor.red, stepsPerStop);
    double greenDelta = _computeDelta(startColor.green, endColor.green, stepsPerStop);
    double blueDelta = _computeDelta(startColor.blue, endColor.blue, stepsPerStop);

    return ColorIncrement(redDelta: redDelta, greenDelta: greenDelta, blueDelta: blueDelta, alphaDelta: 0);
  }

  double _computeDelta(int startColorComponent, int endColorComponent, int steps) {
    return (endColorComponent - startColorComponent) / steps;
  }

  void resetPosition({int stop = 0, int position = 0}) {
    _currentStop = min(stop, colorStops.length);
    _currentPosition = 0;
    _currentColor = colorStops[_currentStop];

    if (position != 0) {
      // Advance _currentPosition to desired position.  It is necessary to do it this way
      // so that the color advances appropriately.
      for (int pos = 0; pos < position; pos++) {
        next();
      }
    }
  }

  Color get color => _currentColor;

  void next() {
    final currentIncrement = _increments[_currentStop];
    _currentColor = currentIncrement.newColor(_currentColor);

    if (++_currentPosition >= stepsPerStop) {
      // Next position in stop
      _currentPosition = 0;

      if (++_currentStop >= colorStops.length) {
        // Wrap around to first stop
        _currentStop = 0;
      }
    }
  }
}