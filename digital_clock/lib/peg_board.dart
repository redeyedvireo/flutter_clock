// Keeps track of the entire board.  Kinda like an off-screen buffer, but for pegs.

import 'package:flutter/material.dart';
import 'dart:math';

import 'peg_data.dart';
import 'numbers.dart';

class PegBoard {
  static const pegWidth = 30;
  static const pegHeight = 18;
  static const numberWidth = 5;     // Width of a number, in pegs
  static const numberHeight = 16;   // Height of a number, in pegs
  static const spaceWidth = 2;      // Width of space, in pegs
  static const colonWidth = 2;      // Width of the colon, in pegs

  // x value of the left side of each number "slot".  A slot is where a number will appear.
  static const numberSlotLeftPegIds = [0, 7, 18, 25];

  final totalPegs = pegWidth * pegHeight;
  Random _random;

  final blankPeg = Color.fromRGBO(0, 0, 0, 0.0);
  final whitePeg = Colors.white;

  Map<int, PegData>   _pegs = {};

  PegBoard() {
    _random = Random(DateTime.now().second);

    // Create pegs
    for (int i = 0; i < totalPegs; i++) {
      _pegs[i] = PegData(color: blankPeg);
    }
  }

  PegData getPeg(int index) => _pegs[index];

  Color _randomColor() {
    final red = _random.nextInt(256);
    final green = _random.nextInt(256);
    final blue = _random.nextInt(256);

    return Color.fromRGBO(red, green, blue, 1.0);
  }

  // Set pegs to a random color
  void generateRandomBoard() {
    for (int i = 0; i < totalPegs; i++) {
      _pegs[i].color = _randomColor();
    }
  }

  int _pegId(int x, int y) => y * pegWidth + x;

  void clearBorder(int borderWidth) {
    // Top row
    for (int i = 0; i < borderWidth; i++) {
      clearPegRow(i);
    }

    // Bottom row
    for (int i = 0; i < borderWidth; i++) {
      clearPegRow(pegHeight - 1 - i);
    }

    // Left side
    for (int i = 0; i < borderWidth; i++) {
      clearPegColumn(i);
    }

    // Right side
    for (int i = 0; i < borderWidth; i++) {
      clearPegColumn(pegWidth - 1 - i);
    }
  }

  void clearPegRow(int row) {
    int startPegId = row * pegWidth;

    for (int i = 0; i < pegWidth; i++) {
      _pegs[i + startPegId].color = blankPeg;
    }
  }

  void clearPegColumn(int column) {
    for (int i = 0, pegId = column; i < pegHeight; i++, pegId += pegWidth) {
      _pegs[pegId].color = blankPeg;
    }
  }

  void clearPegArea(int x, int y, int width, int height) {
    int leftPegId = _pegId(x, y);
    int curPegId = leftPegId;

    for (int i = 0; i < height; i++) {
      for (int j = 0; j < width; j++) {
        _pegs[curPegId].color = blankPeg;
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

    int leftPegId = _pegId(numberSlotLeftPegIds[slot], rowOffset);
    int curPegId = leftPegId;

    int dataOffset = 0;
    for (int i = 0; i < numberDataHeight; i++) {
      for (int j = 0; j < numberWidth; j++) {
        if (numberData[dataOffset] == 1) {
          _pegs[curPegId].color = whitePeg;
        } else {
          _pegs[curPegId].color = blankPeg;
        }

        dataOffset++;
        curPegId++;
      }

      leftPegId += pegWidth;
      curPegId = leftPegId;
    }
  }
}