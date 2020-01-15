import 'package:digital_clock/peg_board.dart';
import 'package:flutter/material.dart';

import 'background_manager.dart';

import '../elapsed_time.dart';
import '../color_gradient.dart';

class BackgroundGradient implements IBackground {
  PegBoard pegBoard;

  ElapsedTime _backgroundUpdateElapsedTime;

  ColorGradient colorGradient;

  int _currentStop;
  int _currentPositionInStop;
  int _backgroundGradientSteps = 30;

  BackgroundGradient({@required this.pegBoard}) {
      _currentStop = 0;
      _currentPositionInStop = 0;

      _backgroundUpdateElapsedTime = ElapsedTime(targetMilliseconds: 1000);

      // Color values are from: https://en.wikipedia.org/wiki/RGB_color_model
      colorGradient = ColorGradient(colorStops: [
        Color.fromARGB(255, 127, 0, 255),       // Violet
        Color.fromARGB(255, 0, 0, 255),         // Blue
        Color.fromARGB(255, 0, 127, 255),       // Azure
        Color.fromARGB(255, 0, 255, 255),       // Cyan
        Color.fromARGB(255, 0, 255, 127),       // Spring
        Color.fromARGB(255, 0, 255, 0),         // Green
        Color.fromARGB(255, 128, 255, 0),       // Chartreuse
        Color.fromARGB(255, 255, 255, 0),       // Yellow
        Color.fromARGB(255, 255, 127, 0),       // Orange
        Color.fromARGB(255, 255, 0, 0),         // Red
        Color.fromARGB(255, 255, 0, 127),       // Rose
        Color.fromARGB(255, 255, 0, 255),       // Magenta
      ], stepsPerStop: _backgroundGradientSteps);
  }

  void draw() {
    if (_backgroundUpdateElapsedTime.timesUp()) {
      if (++_currentPositionInStop >= _backgroundGradientSteps) {
        // Next stop position
        _currentPositionInStop = 0;

        if (++_currentStop >= colorGradient.colorStops.length) {
          // Wrap around to first stop
          _currentStop = 0;
        }
      }
    }

    colorGradient.resetPosition(stop: _currentStop, position: _currentPositionInStop);

    for (int column = 0; column < PegBoard.pegWidth; column++) {
      pegBoard.fillPegArea(column, 0, 1, PegBoard.pegHeight, colorGradient.color);
      colorGradient.next();
    }
  }
}