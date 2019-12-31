import 'package:flutter/material.dart';

import 'package:digital_clock/effects/effect.dart';
import 'package:digital_clock/peg_board.dart';

class EffectVerticalLine extends Effect {

  int currentColumn;
  int finalColumn;

  EffectVerticalLine(PegBoard pegBoard, int frameDuration) :
        super(pegBoard: pegBoard, frameDuration: frameDuration) {
    currentColumn = 0;
    finalColumn = PegBoard.pegWidth - 1;
  }

  @override
  bool drawFrame(bool updateNeeded) {
    // No need to call the base class, since it doesn't do anything.
    pegBoard.fillPegArea(currentColumn, 0, 1, PegBoard.pegHeight, Colors.white);

    if (updateNeeded) {
      // Update the column
      currentColumn++;
    }

    if (currentColumn > finalColumn) {
      return false;   // Finished
    } else {
      return true;
    }
  }
}