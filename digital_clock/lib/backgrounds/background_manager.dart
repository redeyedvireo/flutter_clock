import 'package:digital_clock/peg_board.dart';
import 'dart:math';

import '../elapsed_time.dart';

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
  Random _random;
  List<IBackground> backgrounds = [];
  int currentBackground = 0;
  ElapsedTime _elapsedTime;
  static int minutesUntilChangeBackground = 20;

  BackgroundManager() {
    _random = Random(DateTime.now().second);
    _elapsedTime =
        ElapsedTime(targetMilliseconds: minutesUntilChangeBackground * 60000);
  }

  void createBackgrounds() {
    backgrounds.add(BackgroundGradient(pegBoard: pegBoard));
    backgrounds.add(BackgroundColorFader(pegBoard: pegBoard));
    backgrounds.add(BackgroundColorCycler(pegBoard: pegBoard));
    backgrounds.add(BackgroundStars(pegBoard: pegBoard));
    backgrounds.add(BackgroundTheMatrix(pegBoard: pegBoard));
    backgrounds.add(BackgroundAquarium(pegBoard: pegBoard));

    _setCurrentBackground();
  }

  void _setCurrentBackground() {
    final previousBackground = currentBackground;

    int newBackground = _random.nextInt(backgrounds.length);
    while (newBackground == previousBackground) {
      newBackground = _random.nextInt(backgrounds.length);
    }

    currentBackground = newBackground;
  }

  void drawBackground() {
    if (_elapsedTime.timesUp()) {
      // Change background every minutesUntilChangeBackground minutes
      _setCurrentBackground();
      _elapsedTime.reset();
    }

    if (backgrounds.length > 0) {
      backgrounds[currentBackground].draw();
    }
  }
}
