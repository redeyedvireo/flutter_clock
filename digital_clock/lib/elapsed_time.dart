import 'package:flutter/material.dart';

/// Determines when a given number of milliseconds have elapsed.
class ElapsedTime {
  int targetMilliseconds;
  DateTime _lastTriggerTime;

  ElapsedTime({@required this.targetMilliseconds}) {
    reset();
  }

  void reset() {
    _lastTriggerTime = DateTime.now();
  }

  bool timesUp() {
    bool needsRetrigger = false;
    DateTime current = DateTime.now();

    final timePassedSinceLastTrigger = current.difference(_lastTriggerTime);

    if (timePassedSinceLastTrigger.inMilliseconds >= targetMilliseconds) {
      needsRetrigger = true;
      _lastTriggerTime = current;
    }

    return needsRetrigger;
  }
}
