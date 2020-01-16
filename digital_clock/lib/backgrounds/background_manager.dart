import 'package:digital_clock/backgrounds/background_color_fader.dart';

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
  int currentBackground = 1;

  BackgroundManager();

  void createBackgrounds() {
    backgrounds.add(BackgroundGradient(pegBoard: pegBoard));
    backgrounds.add(BackgroundColorFader(pegBoard: pegBoard));
  }

  void drawBackground() {
    if (backgrounds.length > 0) {
      backgrounds[currentBackground].draw();
    }
  }
}