import 'package:digital_clock/peg_board.dart';
import 'package:flutter/material.dart';

import 'effect.dart';
import 'effect_vert_line.dart';

class EffectsManager {
  PegBoard pegBoard;
  List<Effect> effects = [];
  DateTime _lastEffectUpdateTime;

  EffectsManager() {
    _lastEffectUpdateTime = DateTime.now();
  }

  void addVerticalLineEffect(int frameDuration) {
    final effect = EffectVerticalLine(pegBoard, frameDuration);
    _addEffect(effect);
  }

  int _getAvailableIndex() {
    int numEffects = effects.length;

    for (int index = 0; index < numEffects; index++) {
      if (effects[index] == null) {
        return index;
      }
    }

    // No free slots found.
    return -1;
  }

  void _addEffect(Effect effect) {
    final index = _getAvailableIndex();

    if (index == -1) {
      effects.add(effect);
    } else {
      effects[index] = effect;
    }
  }

  /// Triggers the next animation frame for all effects.
  void next() {
    List<int> finishedEffectIndexes = [];

    effects.asMap().forEach((int index, Effect effect) {
      if (effect != null) {
        final stillActive = effect.next();

        if (!stillActive) {
          // Effect is done - add it to the list of effects to remove
          finishedEffectIndexes.add(index);
        }
      }
    });

    _lastEffectUpdateTime = DateTime.now();

    // Remove finished effects
    finishedEffectIndexes.forEach((int index) {
      effects[index] = null;
    });

    _checkIfTimeToSpawnNewEffect();
  }

  /// Check if a new effect should be spawned.
  void _checkIfTimeToSpawnNewEffect() {
    final timePassedSinceLastEffectUpdate = DateTime.now().difference(_lastEffectUpdateTime);

    if (timePassedSinceLastEffectUpdate.inSeconds >= 5) {
      // There has not been an effect in a while.  Spawn a new one.
      addVerticalLineEffect(150);
    }
  }
}