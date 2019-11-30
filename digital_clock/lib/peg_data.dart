import 'package:flutter/material.dart';

import 'peg_widget.dart';

enum PegType {
  background,
  effect,
  digit
}

class PegData {
  Color color;
  PegType pegType;

  PegData({this.color, this.pegType});
}