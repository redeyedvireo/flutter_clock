import 'package:flutter/material.dart';

import 'package:digital_clock/effects/effect.dart';
import 'package:digital_clock/peg_board.dart';

class EffectExpandingBox extends Effect {
  int boxX, boxY, boxWidth, boxHeight;
  Color boxColor;

  EffectExpandingBox(PegBoard pegBoard, int frameDuration)
      : super(pegBoard: pegBoard, frameDuration: frameDuration) {
    boxWidth = 16;
    boxHeight = 2;
    _computeXY();

    boxColor = pegBoard.randomColor(1.0);
  }

  void _computeXY() {
    boxX = (PegBoard.pegWidth - boxWidth) ~/ 2;
    boxY = (PegBoard.pegHeight - boxHeight) ~/ 2;
  }

  @override
  bool drawFrame(bool updateNeeded) {
    // No need to call the base class, since it doesn't do anything.
    pegBoard.drawBox(boxX, boxY, boxWidth, boxHeight, boxColor);

    if (updateNeeded) {
      boxWidth += 2;
      boxHeight += 2;
      _computeXY();
    }

    if (boxX < 0 ||
        boxX + boxWidth > PegBoard.pegWidth - 1 ||
        boxY < 0 ||
        boxY + boxHeight > PegBoard.pegHeight - 1) {
      return false; // Finished
    } else {
      return true;
    }
  }
}
