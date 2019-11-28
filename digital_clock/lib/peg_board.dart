// Keeps track of the entire board.
import 'package:flutter/material.dart';
import 'dart:math';

import 'peg_data.dart';

class PegBoard {
  static const pegWidth = 25;
  static const pegHeight = 14;

  final totalPegs = pegWidth * pegHeight;
  Random _random;

  Map<int, PegData>   _pegs = {};

  PegBoard() {
    _random = Random(DateTime.now().second);

    // Create pegs
    for (int i = 0; i < totalPegs; i++) {
      _pegs[i] = PegData(color: Colors.black);
    }
  }

  PegData getPeg(int index) => _pegs[index];

  Color _randomColor() {
    final red = _random.nextInt(256);
    final green = _random.nextInt(256);
    final blue = _random.nextInt(256);

    return Color.fromRGBO(red, green, blue, 1.0);
  }

  // Set pegs to a random color
  void generateRandomBoard() {
    for (int i = 0; i < totalPegs; i++) {
      _pegs[i].color = _randomColor();
    }
  }
}