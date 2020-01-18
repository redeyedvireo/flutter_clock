import 'package:flutter/material.dart';

import 'coord.dart';
import 'sprite.dart';
import 'elapsed_time.dart';


class SpriteMover {
  Function isDone;
  Function doneCallback;
  int id;           // Caller-supplied ID value; used only by the caller
  Sprite sprite;
  Coord start;
  Coord increment;
  int frameMs;      // Number of milliseconds the sprite should remain at each position
  ElapsedTime _elapsedTime;

  Coord _currentPos;

  SpriteMover({@required this.sprite,
                @required this.id,
                @required this.start,
                @required this.increment,
                @required this.frameMs,
                @required this.isDone,
                @required this.doneCallback}) {
    _elapsedTime = ElapsedTime(targetMilliseconds: frameMs);
    _currentPos = start;
  }

  void next() {
    // Check if the sprite is done
    if (isDone(_currentPos.x, _currentPos.y)) {
      doneCallback(id);
    } else {
      if (_elapsedTime.timesUp()) {
        _currentPos = _currentPos + increment;
        _elapsedTime.reset();
      }

      sprite.draw(_currentPos.x, _currentPos.y);
    }
  }
}