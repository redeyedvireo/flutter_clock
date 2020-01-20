// Keeps track of the entire board.  Kinda like an off-screen buffer, but for pegs.

import 'package:flutter/material.dart';
import 'dart:math';

import 'coord.dart';
import 'peg_data.dart';
import 'numbers.dart';
import 'color_fader.dart';

class PegBoard {
  static const pegWidth = 30;
  static const pegHeight = 18;
  static const maxPegId = pegWidth * pegHeight - 1;
  static const numberWidth = 6; // Width of a number, in pegs
  static const numberHeight = 11; // Height of a number, in pegs
  static const spaceWidth = 2; // Width of space, in pegs
  static const colonWidth = 2; // Width of the colon, in pegs
  static const colonTop = 5; // Top row of top of colon (the top 'dot')
  static const colonX = 14; // Left edge of colons
  static const interDigitSpace = 1; // Spacing between digits

  // x value of the left side of each number "slot".  A slot is where a number will appear.
  List<int> numberSlotLeftPegIds;

  final totalPegs = pegWidth * pegHeight;
  Random _random;

  Color globalBackgroundColor = PegData.blankPeg;
  Color digitColor = PegData.whitePeg;

  // Color deltas for digit color
  int digitRedDelta = 0;
  int digitBlueDelta = 0;
  int digitGreenDelta = 0;

  Map<int, PegData> _pegs = {};

  PegBoard() {
    _random = Random(DateTime.now().second);

    _initDigits();
    _initBackground();
    setRandomDigitColor();

    // Create pegs
    for (int i = 0; i < totalPegs; i++) {
      _pegs[i] = PegData(color: PegData.blankPeg, pegType: PegType.background);
    }
  }

  PegData getPeg(int index) => _pegs[index];

  Color randomColor(double opacity) {
    final red = _random.nextInt(256);
    final green = _random.nextInt(256);
    final blue = _random.nextInt(256);

    return Color.fromRGBO(red, green, blue, opacity);
  }

  Color randomBrightColor(double opacity) {
    final red = _random.nextInt(156) + 100;
    final green = _random.nextInt(156) + 100;
    final blue = _random.nextInt(156) + 100;

    return Color.fromRGBO(red, green, blue, opacity);
  }

  Color randomDarkColor(double opacity) {
    final red = _random.nextInt(100) + 10;
    final green = _random.nextInt(100) + 10;
    final blue = _random.nextInt(100) + 10;

    return Color.fromRGBO(red, green, blue, opacity);
  }

  // Set pegs to a random color
  void generateRandomBoard() {
    for (int i = 0; i < totalPegs; i++) {
      _pegs[i].pegColor = randomColor(1.0);
    }
  }

  void _initDigits() {
    final hour1Left = colonX - interDigitSpace - numberWidth;
    final hour0Left = hour1Left - interDigitSpace - numberWidth;

    final minute0Left = colonX + colonWidth + interDigitSpace;
    final minute1Left = minute0Left + numberWidth + interDigitSpace;

    numberSlotLeftPegIds = [hour0Left, hour1Left, minute0Left, minute1Left];
  }

  void _initBackground() {
    setRandomBackgroundColor(0.5);
  }

  void setRandomBackgroundColor(double opacity) {
    globalBackgroundColor = randomColor(opacity);
  }

  void setRandomDigitColor() {
    digitColor = randomColor(1.0);

    digitRedDelta = _random.nextInt(12) * (_random.nextInt(7) > 3 ? 1 : -1);
    digitBlueDelta = _random.nextInt(12) * (_random.nextInt(7) > 3 ? 1 : -1);
    digitGreenDelta = _random.nextInt(12) * (_random.nextInt(7) > 3 ? 1 : -1);
  }

  int pegId(int x, int y) => y * pegWidth + x;
  int pegIdCoord(Coord c) => c.y * pegWidth + c.x;

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
    fillPegArea(x, y, width, height, globalBackgroundColor);
  }

  void fillPegArea(int x, int y, int width, int height, Color color) {
    int leftPegId = pegId(x, y);
    int curPegId = leftPegId;

    for (int i = 0; i < height; i++) {
      for (int j = 0; j < width; j++) {
        _pegs[curPegId].pegColor = color;
        curPegId++;
      }

      leftPegId += pegWidth;
      curPegId = leftPegId;
    }
  }

  void fillPegAreaWithColorFader(
      int x, int y, int width, int height, ColorFader colorFader) {
    int leftPegId = pegId(x, y);
    int curPegId = leftPegId;

    colorFader.start();

    for (int i = 0; i < height; i++) {
      for (int j = 0; j < width; j++) {
        _pegs[curPegId].pegColor = colorFader.color;
        curPegId++;
      }

      leftPegId += pegWidth;
      curPegId = leftPegId;
      colorFader.nextStep();
    }
  }

  void drawHLine(int x, int y, int length, Color color) {
    int leftPegId = pegId(x, y);
    int curPegId = leftPegId;

    for (int i = 0; i < length; i++) {
      _pegs[curPegId++].pegColor = color;
    }
  }

  void drawVLine(int x, int y, int length, Color color) {
    int leftPegId = pegId(x, y);
    int curPegId = leftPegId;

    for (int i = 0; i < length; i++) {
      _pegs[curPegId].pegColor = color;
      curPegId += pegWidth;
    }
  }

  void drawBox(int x, int y, int width, int height, Color color) {
    drawHLine(x, y, width, color);
    drawHLine(x, y + height - 1, width, color);

    drawVLine(x, y + 1, height - 2, color);
    drawVLine(x + width - 1, y + 1, height - 2, color);
  }

  void placeNumberOnSlot(int slot, int number) {
    _drawDigit(
        numberSlotLeftPegIds[slot], numberWidth, numberHeight, numbers[number]);
  }

  void drawColon() {
    _drawDigit(colonX, colonWidth, numberHeight, colon);
  }

  void _drawDigit(int x, int width, int height, List<int> data) {
    final rowOffset = (pegHeight - height) ~/ 2;
    final colorFader = ColorFader(
        startColor: digitColor,
        redDelta: digitRedDelta,
        blueDelta: digitBlueDelta,
        greenDelta: digitGreenDelta);

    int leftPegId = pegId(x, rowOffset);
    int curPegId = leftPegId;

    int dataOffset = 0;
    for (int i = 0; i < height; i++) {
      for (int j = 0; j < width; j++) {
        if (data[dataOffset] == 1) {
          _pegs[curPegId].pegColor = PegData.whitePeg;
        }

        dataOffset++;
        curPegId++;
      }

      leftPegId += pegWidth;
      curPegId = leftPegId;
//      colorFader.nextStep();
    }
  }
}
