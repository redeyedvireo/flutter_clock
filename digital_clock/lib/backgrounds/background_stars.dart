import 'package:flutter/material.dart';
import 'dart:math';

import 'package:digital_clock/peg_board.dart';
import 'package:digital_clock/peg_data.dart';

import 'background_manager.dart';

enum StarState { newStar, twinkling, fadingIn, fadingOut, normal }

class Star {
  int x;
  int y;
  Color color;
  PegBoard pegBoard;
  Random random;
  static int lifeTimeSeconds = 25;
  static int minLifetimeSeconds = 10;

  StarState state = StarState.newStar;
  static int alphaStep = 25;
  int currentAlpha = 0;
  DateTime doneTime;

  Star(
      {@required this.x,
      @required this.y,
      @required this.color,
      @required this.pegBoard,
      @required this.random}) {
    doneTime = DateTime.now().add(Duration(
        seconds: random.nextInt(lifeTimeSeconds) + minLifetimeSeconds));
  }

  // The return value indicates if the star should continue to be displayed.
  bool draw() {
    bool returnValue = true;

    switch (state) {
      case StarState.newStar:
        // Start fading
        state = StarState.fadingIn;
        pegBoard.getPeg(pegBoard.pegId(x, y)).pegColor =
            color.withAlpha(currentAlpha);
        break;

      case StarState.fadingIn:
        currentAlpha = min(currentAlpha + alphaStep, 255);
        pegBoard.getPeg(pegBoard.pegId(x, y)).pegColor =
            color.withAlpha(currentAlpha);

        if (currentAlpha == 255) {
          state = StarState.normal;
        }
        break;

      case StarState.fadingOut:
        currentAlpha = max(currentAlpha - alphaStep, 0);
        pegBoard.getPeg(pegBoard.pegId(x, y)).pegColor =
            color.withAlpha(currentAlpha);

        if (currentAlpha == 0) {
          // The star is finished
          returnValue = false;
        }
        break;

      case StarState.normal:
        pegBoard.getPeg(pegBoard.pegId(x, y)).pegColor = color;

        if (DateTime.now().isAfter(doneTime)) {
          state = StarState.fadingOut;
        }
        break;

      default:
        pegBoard.getPeg(pegBoard.pegId(x, y)).pegColor = color;
    }

    return returnValue;
  }
}

class BackgroundStars implements IBackground {
  PegBoard pegBoard;
  Random _random;
  final numStars = 40;
  List<Star> _stars = [];

  BackgroundStars({@required this.pegBoard}) {
    _random = Random(DateTime.now().second);

    // Create stars
    for (int i = 0; i < numStars; i++) {
      _createStar();
    }
  }

  void _createStar() {
    final star = Star(
        x: _random.nextInt(PegBoard.pegWidth),
        y: _random.nextInt(PegBoard.pegHeight),
        color: pegBoard.randomColor(1.0),
        pegBoard: pegBoard,
        random: _random);

    _stars.add(star);
  }

  void draw() {
    for (int i = 0; i < pegBoard.totalPegs; i++) {
      pegBoard.getPeg(i).pegColor = PegData.blackPeg;
    }

    List<int> starIndexesToRemove = [];

    for (int j = 0; j < _stars.length; j++) {
      final star = _stars[j];
      final continueToDisplay = star.draw();

      if (!continueToDisplay) {
        starIndexesToRemove.add(j);
      }
    }

    // Remove finished stars
    if (starIndexesToRemove.length > 0) {
      // Must remove in reverse order, due to subsequent index values shifting when items are removed.
      for (int k = starIndexesToRemove.length - 1; k >= 0; k--) {
        _stars.removeAt(starIndexesToRemove[k]);
      }

      // Create new star(s) to replace the old ones.
      for (int m = 0; m < starIndexesToRemove.length; m++) {
        _createStar();
      }
    }
  }
}
