import 'package:flutter/material.dart';
import 'dart:math';

import 'effect.dart';
import '../peg_board.dart';
import '../color_fader.dart';

class BoxData {
  int boxX, boxY, boxWidth, boxHeight;
  Color boxColor;
  PegBoard pegBoard;

  BoxData(this.boxX, this.boxWidth, this.boxY, this.boxHeight, this.boxColor, this.pegBoard);

  /// Increments the box by the given size.
  /// Returns true if the box is still within bounds; false if not.
  bool next() {
    boxX -= 1;
    boxY -= 1;
    boxWidth += 2;
    boxHeight += 2;

    return (boxX >= 0 && boxX + boxWidth <= PegBoard.pegWidth &&
        boxY >= 0 && boxY + boxHeight <= PegBoard.pegHeight);

  }

  void draw() {
    pegBoard.drawBox(boxX, boxY, boxWidth, boxHeight, boxColor);
  }
}

class EffectExpandingFilledBox extends Effect {
  Random _random;
  List<BoxData> _boxData = [];
  bool createNewBoxes = true;
  ColorFader _colorFader;
  int _colorDelta;

  EffectExpandingFilledBox(PegBoard pegBoard, int frameDuration) :
        super(pegBoard: pegBoard, frameDuration: frameDuration) {
    _random = Random(DateTime.now().second);
    _colorDelta = _random.nextInt(15) + 10;
    _colorFader = ColorFader(startColor: pegBoard.randomBrightColor(1.0),
                              redDelta: -_colorDelta,
                              blueDelta: -_colorDelta,
                              greenDelta: -_colorDelta);

    _createNewBox();
  }

  void _createNewBox() {
    final initialBoxHeight = 2;
    final initialBoxY = (PegBoard.pegHeight - initialBoxHeight) ~/ 2;

    final initialBoxX = initialBoxY;
    final initialBoxWidth = PegBoard.pegWidth - 2 * initialBoxX;

    BoxData boxData = BoxData(initialBoxX, initialBoxWidth,
                              initialBoxY, initialBoxHeight, _colorFader.color, pegBoard);

    _colorFader.nextStep();
    _boxData.add(boxData);
  }

  @override
  bool drawFrame(bool updateNeeded) {
    // No need to call the base class, since it doesn't do anything.
    _boxData.forEach((BoxData boxData) {
      boxData.draw();
    });

    if (updateNeeded) {
      int numBoxes = _boxData.length;
      int numBoxesToRemove = 0;

      for (int i = 0; i < numBoxes; i++) {
        final boxData = _boxData[i];

        final stillWithinBounds = boxData.next();

        if (!stillWithinBounds) {
          // Once a box hits the boundary, stop creating new boxes
          createNewBoxes = false;
          numBoxesToRemove++;
        }
      }

      if (createNewBoxes) {
        _createNewBox();
      }

      if (numBoxesToRemove > 0) {
        _boxData.removeRange(0, numBoxesToRemove);
      }
    }

    if (_boxData.length == 0) {
      return false;   // Finished
    } else {
      return true;
    }
  }
}