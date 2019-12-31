import 'package:flutter/material.dart';
import '../peg_board.dart';

class Effect {
  PegBoard pegBoard;

  // Duration of each frame, in milliseconds.
  int frameDuration;

  DateTime timeOfCurrentFrame;
  DateTime timeOfNextFrame;

  Effect({@required this.pegBoard, @required this.frameDuration});

  // Triggers the effect to start the next frame in its animation.
  // Return value: true if the effect is still active, false if the effect is finished.
  bool next() {
    final needsUpdate = isTimeForUpdate();

    return drawFrame(needsUpdate);
  }

  /// Determines if it is time to update the frame.
  bool isTimeForUpdate() {
    bool needsUpdate = false;

    if (timeOfCurrentFrame == null) {
      // First time this frame has been drawn.
      timeOfCurrentFrame = DateTime.now();
      timeOfNextFrame = timeOfCurrentFrame.add(Duration(milliseconds: frameDuration));
    } else {
      DateTime currently = DateTime.now();

      if (currently.isAtSameMomentAs(timeOfNextFrame) || currently.isAfter(timeOfNextFrame)) {
        // The current time is at or after the time at which the new frame needs to be drawn.
        needsUpdate = true;

        // Compute time at which the next frame should be drawn

        // Amount we've overshot the originally planned time of the next frame
        Duration deltaMilliseconds = currently.difference(timeOfNextFrame);
        int remainingMilliseconds = frameDuration - deltaMilliseconds.inMilliseconds;

        timeOfNextFrame = currently.add(Duration(milliseconds: remainingMilliseconds));
        timeOfCurrentFrame = currently;
      } else {
        needsUpdate = false;
      }
    }

    return needsUpdate;
  }

  // Will be overridden by subclasses
  // The updateNeeded parameter indicates if the frame needs to be updated.
  // Return value: true if the effect is still active, false if the effect is finished.
  bool drawFrame(bool updateNeeded) {
    return false;
  }
}