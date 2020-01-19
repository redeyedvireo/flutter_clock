import 'package:digital_clock/peg_board.dart';

import 'background_gradient.dart';
import 'background_color_cycler.dart';
import 'background_color_fader.dart';
import 'background_stars.dart';
import 'background_the_matrix.dart';
import 'background_aquarium.dart';


// Interface class for backgrounds
class IBackground {

  // Draw the background.  Will be called every timer tick.
  void draw() {}
}


class BackgroundManager {
  PegBoard pegBoard;
  List<IBackground> backgrounds = [];
  int currentBackground = 5;

  BackgroundManager();

  void createBackgrounds() {
    backgrounds.add(BackgroundGradient(pegBoard: pegBoard));
    backgrounds.add(BackgroundColorFader(pegBoard: pegBoard));
    backgrounds.add(BackgroundColorCycler(pegBoard: pegBoard));
    backgrounds.add(BackgroundStars(pegBoard: pegBoard));
    backgrounds.add(BackgroundTheMatrix(pegBoard: pegBoard));
    backgrounds.add(BackgroundAquarium(pegBoard: pegBoard));
  }


  // TODO: Change background periodically - every hour perhaps?


  void drawBackground() {
    if (backgrounds.length > 0) {
      backgrounds[currentBackground].draw();
    }
  }
}