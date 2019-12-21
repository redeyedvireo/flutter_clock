// Keeps track of the entire board.  Kinda like an off-screen buffer, but for pegs.

import 'package:digital_clock/color_cyler.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'peg_data.dart';
import 'numbers.dart';
import 'color_fader.dart';

class PegBoard {
  static const pegWidth = 30;
  static const pegHeight = 18;
  static const numberWidth = 5;     // Width of a number, in pegs
  static const numberHeight = 16;   // Height of a number, in pegs
  static const spaceWidth = 2;      // Width of space, in pegs
  static const colonWidth = 2;      // Width of the colon, in pegs
  static const colonTop = 5;        // Top row of top of colon (the top 'dot')

  // x value of the left side of each number "slot".  A slot is where a number will appear.
  static const numberSlotLeftPegIds = [2, 8, 17, 23];

  final totalPegs = pegWidth * pegHeight;
  Random _random;

  Color globalBackgroundColor = PegData.blankPeg;
  Color digitColor = PegData.whitePeg;

  // Color deltas for background color 
  int redDelta = 0;
  int blueDelta = 0;
  int greenDelta = 0;
  
  // Color deltas for digit color
  int digitRedDelta = 0;
  int digitBlueDelta = 0;
  int digitGreenDelta = 0;

  ColorCycler colorCycler;
  double colorCycleScaleFactor = 20.0;

  Map<int, PegData>   _pegs = {};

  PegBoard() {
    _random = Random(DateTime.now().second);

    setRandomBackgroundColor(0.5);
    setRandomDigitColor();

    colorCycler = ColorCycler(redMin: 100, redMax: 150,
                              greenMin: 100, greenMax: 150,
                              blueMin: 100, blueMax: 150,
                              redDelta: (_random.nextDouble() * 10 + 5) / colorCycleScaleFactor,
                              greenDelta: (_random.nextDouble() * 10 + 5) / colorCycleScaleFactor,
                              blueDelta: (_random.nextDouble() * 10 + 5) / colorCycleScaleFactor,
                              alpha: 150);

    // Create pegs
    for (int i = 0; i < totalPegs; i++) {
      _pegs[i] = PegData(color: PegData.blankPeg, pegType: PegType.background);
    }
  }

  PegData getPeg(int index) => _pegs[index];

  Color _randomColor(double opacity) {
    final red = _random.nextInt(256);
    final green = _random.nextInt(256);
    final blue = _random.nextInt(256);

    return Color.fromRGBO(red, green, blue, opacity);
  }

  // Set pegs to a random color
  void generateRandomBoard() {
    for (int i = 0; i < totalPegs; i++) {
      _pegs[i].backgroundColor = _randomColor(1.0);
    }
  }

  void setRandomBackgroundColor(double opacity) {
    globalBackgroundColor = _randomColor(opacity);

    redDelta = _random.nextInt(12) * (_random.nextInt(7) > 3 ? 1 : -1);
    blueDelta = _random.nextInt(12) * (_random.nextInt(7) > 3 ? 1 : -1);
    greenDelta = _random.nextInt(12) * (_random.nextInt(7) > 3 ? 1 : -1);
  }

  void setRandomDigitColor() {
    digitColor = _randomColor(1.0);

    digitRedDelta = _random.nextInt(12) * (_random.nextInt(7) > 3 ? 1 : -1);
    digitBlueDelta = _random.nextInt(12) * (_random.nextInt(7) > 3 ? 1 : -1);
    digitGreenDelta = _random.nextInt(12) * (_random.nextInt(7) > 3 ? 1 : -1);
  }
  
  int _pegId(int x, int y) => y * pegWidth + x;

  void drawBackground() {
    _drawBackgroundWithColorCycler();
  }

  void _drawBackgroundWithColorCycler() {
    fillPegArea(0, 0, pegWidth, pegHeight, colorCycler.color, PegType.background);
    colorCycler.next();
  }

  void _drawBackgroundWithFader() {
    final colorFader = ColorFader(color: globalBackgroundColor, redDelta: redDelta, blueDelta: blueDelta, greenDelta: greenDelta);

    int leftPegId = _pegId(0, 0);
    int curPegId = leftPegId;

    for (int i = 0; i < pegHeight; i++) {
      for (int j = 0; j < pegWidth; j++) {
        // _pegs[curPegId].setPegType(PegData.blankPeg, PegType.background);   // DEBUG
        _pegs[curPegId].setPegType(colorFader.color, PegType.background);
        curPegId++;
      }

      leftPegId += pegWidth;
      curPegId = leftPegId;
      colorFader.nextStep();
    }
  }

  void clearBorder(int borderWidth) {
    // Top row
    clearPegArea(0, 0, pegWidth, borderWidth);

    // Bottom row
    clearPegArea(0, pegHeight - borderWidth, pegWidth, borderWidth);

    // Left side
    clearPegArea(0, 0, borderWidth, pegHeight);

    // Right side
    clearPegArea(pegWidth - borderWidth, 0, borderWidth, pegHeight);
  }

  void clearPegArea(int x, int y, int width, int height) {
    fillPegArea(x, y, width, height, globalBackgroundColor, PegType.background);
  }

  void fillPegArea(int x, int y, int width, int height, Color color, PegType pegType) {
    int leftPegId = _pegId(x, y);
    int curPegId = leftPegId;

    for (int i = 0; i < height; i++) {
      for (int j = 0; j < width; j++) {
        _pegs[curPegId].setPegType(color, pegType);
        curPegId++;
      }

      leftPegId += pegWidth;
      curPegId = leftPegId;
    }
  }

  void clearNumber(int slot) {
    final leftPegId = numberSlotLeftPegIds[slot];
    final y = (pegHeight - numberHeight) ~/ 2;

    clearPegArea(leftPegId, y, numberWidth, numberHeight);
  }

  void placeNumberOnSlot(int slot, int number) {
    final numberData = numbers[number];
    final numberDataHeight = 9; // TODO: Fix this - make numbers 8 or 10 rows
    final rowOffset = (numberHeight - numberDataHeight) ~/ 2 + 1;
    final colorFader = ColorFader(color: digitColor, redDelta: digitRedDelta, blueDelta: digitBlueDelta, greenDelta: digitGreenDelta);

    int leftPegId = _pegId(numberSlotLeftPegIds[slot], rowOffset);
    int curPegId = leftPegId;

    int dataOffset = 0;
    for (int i = 0; i < numberDataHeight; i++) {
      for (int j = 0; j < numberWidth; j++) {
        if (numberData[dataOffset] == 1) {
          _pegs[curPegId].digitColor = colorFader.color;
        }

        dataOffset++;
        curPegId++;
      }

      leftPegId += pegWidth;
      curPegId = leftPegId;
      colorFader.nextStep();
    }
  }

  void clearColonArea() {
    clearPegArea(12, 0, 6, pegHeight);
  }

  void drawColon() {
    final colonData = colon;
    final numberDataHeight = 9; // TODO: Fix this - make numbers 8 or 10 rows
    final rowOffset = (numberHeight - numberDataHeight) ~/ 2 + 1;
    final colorFader = ColorFader(color: digitColor, redDelta: digitRedDelta, blueDelta: digitBlueDelta, greenDelta: digitGreenDelta);

    int leftPegId = _pegId(14, rowOffset);
    int curPegId = leftPegId;

    int dataOffset = 0;
    for (int i = 0; i < numberDataHeight; i++) {
      for (int j = 0; j < colonWidth; j++) {
        if (colonData[dataOffset] == 1) {
          _pegs[curPegId].digitColor = colorFader.color;
        }

        dataOffset++;
        curPegId++;
      }

      leftPegId += pegWidth;
      curPegId = leftPegId;
      colorFader.nextStep();
    }
  }
}