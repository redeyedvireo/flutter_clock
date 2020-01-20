import 'package:flutter/material.dart';

enum PegType { background, effect, digit }

class PegData {
  static const blankPeg = Color.fromRGBO(0, 0, 0, 0.0);
  static const whitePeg = Colors.white;
  static const blackPeg = Colors.black;

  Color pegColor = blankPeg;

  PegData({@required Color color, @required pegType}) {
    pegColor = color;
  }
}
