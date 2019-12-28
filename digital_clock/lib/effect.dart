import 'package:flutter/material.dart';
import 'peg_board.dart';

class Effect {
  PegBoard pegBoard;

  // Function called by the effect when the effect is finished.
  Function done;

  // Duration of each frame, in milliseconds.
  int frameDuration;

  DateTime timeOfCurrentFrame;
  DateTime timeOfNextFrame;

  Effect({@required this.pegBoard, @required this.frameDuration});

  // Triggers the effect to start the next frame in its animation.
  // Return value: true if the effect is still active, false if the effect is finished.
  bool next() {
    bool needsDrawing = true;

    if (timeOfCurrentFrame == null) {
      // First time this frame has been drawn.
      timeOfCurrentFrame = DateTime.now();
      timeOfNextFrame = timeOfCurrentFrame.add(Duration(milliseconds: frameDuration));
    } else {
      DateTime currently = DateTime.now();

      if (currently.isAtSameMomentAs(timeOfNextFrame) || currently.isAfter(timeOfNextFrame)) {
        // The current time is at or after the time at which the new frame needs to be drawn.
        needsDrawing = true;

        // Compute time at which the next frame should be drawn

        // Amount we've overshot the originally planned time of the next frame
        Duration deltaMilliseconds = currently.difference(timeOfNextFrame);
        int remainingMilliseconds = frameDuration - deltaMilliseconds.inMilliseconds;

        timeOfNextFrame = currently.add(Duration(milliseconds: remainingMilliseconds));
        timeOfCurrentFrame = currently;
      } else {
        needsDrawing = false;
      }
    }

    if (needsDrawing) {
      return drawFrame();
    }

    return true;
  }

  // Will be overridden by subclasses
  // Return value: true if the effect is still active, false if the effect is finished.
  bool drawFrame() {
    return false;
  }
}