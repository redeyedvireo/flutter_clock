import 'package:flutter/material.dart';

enum ColorElement { red, green, blue }

class ColorCycler {
  double redMin;
  double redMax;

  double greenMin;
  double greenMax;

  double blueMin;
  double blueMax;

  double redDelta;
  double greenDelta;
  double blueDelta;

  double alpha;

  double _red;
  double _green;
  double _blue;

  // Current values
  double _minValue, _maxValue, _currentValue, _increment;

  ColorElement _colorElement;

  Color color;

  ColorCycler(
      {@required this.redMin,
      @required this.redMax,
      @required this.greenMin,
      @required this.greenMax,
      @required this.blueMin,
      @required this.blueMax,
      @required this.redDelta,
      @required this.greenDelta,
      @required this.blueDelta,
      @required this.alpha}) {
    // Set initial color
    _red = redMin;
    _green = greenMin;
    _blue = blueMin;
    _colorElement = ColorElement.red;

    // Start with red being the active cycling color component
    _minValue = redMin;
    _maxValue = redMax;
    _currentValue = _red;
    _increment = redDelta;

    _buildColor();
  }

  void _buildColor() {
    color = Color.fromARGB(
        alpha.round(), _red.round(), _green.round(), _blue.round());
  }

  void next() {
    final returnArray =
        _stepColor(_minValue, _maxValue, _currentValue, _increment);
    _currentValue = returnArray[0];

    switch (_colorElement) {
      case ColorElement.red:
        _red = _currentValue;
        break;

      case ColorElement.green:
        _green = _currentValue;
        break;

      case ColorElement.blue:
        _blue = _currentValue;
        break;
    }

    _buildColor();

    if (!returnArray[1]) {
      // Reverse direction of increment for current color element
      _increment *= -1;

      _saveState(_colorElement);

      // Switch to next color element
      _colorElement = _nextColorElement();

      _restoreState(_colorElement);
    }
  }

  // Changes the color element to the next value in the sequence.
  // The algorithm works as follows:
  //   The increment is added to the current value.  The increment may be
  //   positive or negative.  If the new value exceeds the maximum value, or
  //   undershoots the minimum value, then the value is set to the maximum (in
  //   the former case), or the minimum (in the latter case), and false is returned.
  //
  //   The return value indicates that the increment value should be reversed,
  //   and the next color element used in subsequent steps.
  //
  // The return value is an array:
  //    [ newCurrentValue, boolean indicating if this color element should continue
  //    to be used for the next color cycling step. ]
  //
  List _stepColor(
      double minValue, double maxValue, double currentValue, double increment) {
    double tempValue = currentValue + increment;

    if (increment > 0) {
      if (tempValue > maxValue) {
        // Value exceeded.  Switch to next color element.
        return [maxValue, false];
      } else {
        return [tempValue, true];
      }
    } else {
      if (tempValue < minValue) {
        // Value undershoots min value.  Switch to next color element.
        return [minValue, false];
      } else {
        return [tempValue, true];
      }
    }
  }

  ColorElement _nextColorElement() {
    switch (_colorElement) {
      case ColorElement.red:
        return ColorElement.green;

      case ColorElement.green:
        return ColorElement.blue;

      case ColorElement.blue:
        return ColorElement.red;

      default:
        return ColorElement.red;
    }
  }

  void _saveState(ColorElement colorElement) {
    switch (colorElement) {
      case ColorElement.red:
        redDelta = _increment;
        _red = _currentValue;
        break;

      case ColorElement.green:
        greenDelta = _increment;
        _green = _currentValue;
        break;

      case ColorElement.blue:
        blueDelta = _increment;
        _blue = _currentValue;
        break;
    }
  }

  void _restoreState(ColorElement colorElement) {
    switch (colorElement) {
      case ColorElement.red:
        _increment = redDelta;
        _currentValue = _red;

        _minValue = redMin;
        _maxValue = redMax;
        break;

      case ColorElement.green:
        _increment = greenDelta;
        _currentValue = _green;

        _minValue = greenMin;
        _maxValue = greenMax;
        break;

      case ColorElement.blue:
        _increment = blueDelta;
        _currentValue = _blue;

        _minValue = blueMin;
        _maxValue = blueMax;
        break;
    }
  }
}
