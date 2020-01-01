import 'package:flutter/material.dart';

import 'package:digital_clock/effects/effect.dart';
import 'package:digital_clock/peg_board.dart';

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

  List<BoxData> _boxData = [];
  bool createNewBoxes = true;

  EffectExpandingFilledBox(PegBoard pegBoard, int frameDuration) :
        super(pegBoard: pegBoard, frameDuration: frameDuration) {
    _createNewBox(pegBoard.randomColor(1.0));
  }

  void _createNewBox(Color color) {
    BoxData boxData = BoxData(9, 12, 8, 2, color, pegBoard);
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

        if (createNewBoxes) {
          _createNewBox(pegBoard.randomColor(1.0));
        }
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