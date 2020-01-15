import 'package:flutter/material.dart';

import 'package:digital_clock/peg_board.dart';

import 'background_gradient.dart';

// Interface class for backgrounds
class IBackground {

  // Draw the background.  Will be called every timer tick.
  void draw() {}
}


class BackgroundManager {
  PegBoard pegBoard;
  List<IBackground> backgrounds = [];

  BackgroundManager();

  void createBackgrounds() {
    backgrounds.add(BackgroundGradient(pegBoard: pegBoard));
  }

  void drawBackground() {
    if (backgrounds.length > 0) {
      backgrounds[0].draw();
    }
  }
}