import 'package:flutter/material.dart';
import '../peg_data.dart';

import 'package:digital_clock/effects/effect.dart';
import 'package:digital_clock/peg_board.dart';

class EffectFlashBackground extends Effect {

  List<int> _originalAlphas;
  static const numFlashes = 10;
  int _numberOfFlashes = 0;
  bool _backgroundHidden = false;

  EffectFlashBackground(PegBoard pegBoard, int frameDuration) :
        super(pegBoard: pegBoard, frameDuration: frameDuration) {
    _originalAlphas = List<int>.filled(pegBoard.totalPegs, 0, growable: false);

    _getOriginalAlphas();
  }

  @override
  bool drawFrame(bool updateNeeded) {
    // No need to call the base class, since it doesn't do anything.

    if (_backgroundHidden) {
      _hideBackground();
    }

    if (updateNeeded) {
      _backgroundHidden = !_backgroundHidden;
      _numberOfFlashes++;
    }

    return (_numberOfFlashes <= numFlashes);
  }

  void _getOriginalAlphas() {
    for (int i = 0; i < pegBoard.totalPegs; i++) {
      _originalAlphas[i] = pegBoard.getPeg(i).pegColor.alpha;
    }
  }

  void _hideBackground() {
    for (int i = 0; i < pegBoard.totalPegs; i++) {
      PegData pegData = pegBoard.getPeg(i);
      pegData.pegColor = pegData.pegColor.withAlpha(0);
    }
  }
}