import 'package:flutter/material.dart';

enum PegType {
  background,
  effect,
  digit
}

class PegData {
  static const blankPeg = Color.fromRGBO(0, 0, 0, 0.0);
  static const whitePeg = Colors.white;

  Color _digitColor = blankPeg;
  Color _backgroundColor = blankPeg;
  Color _effectColor = blankPeg;

  PegType _pegType;

  PegData({@required Color color, @required pegType}) {
    _pegType = pegType;

    switch (pegType) {
      case PegType.background:
        _backgroundColor = color;
        break;

      case PegType.digit:
        _digitColor = color;
        break;

      case PegType.effect:
        _effectColor = color;
        break;
    }
  }

  Color get color {
    switch (_pegType) {
      case PegType.background:
        return _backgroundColor;

      case PegType.digit:
        return _digitColor;

      case PegType.effect:
        return _effectColor;
    }
  }

  set digitColor(Color color) {
    _pegType = PegType.digit;
    _digitColor = color;
  }

  set backgroundColor(Color color) {
    _pegType = PegType.background;
    _backgroundColor = color;
  }

  set effectColor(Color color) {
    _pegType = PegType.effect;
    _effectColor = color;
  }

  setPegType(Color color, PegType pegType) {
    _pegType = pegType;

    switch (_pegType) {
      case PegType.background:
        _backgroundColor = color;
        break;

      case PegType.digit:
        _digitColor = color;
        break;

      case PegType.effect:
        _effectColor = color;
        break;
    }
  }
}