import 'package:flutter/material.dart';
import 'dart:math';

import '../peg_board.dart';
import '../peg_data.dart';
import '../coord.dart';
import '../sprites/sprite.dart';
import '../sprites/sprite_mover.dart';
import '../elapsed_time.dart';

import 'background_manager.dart';

class BackgroundTheMatrix implements IBackground {
  PegBoard pegBoard;
  Random _random;
  Sprite _sprite;
  static int numSprites = 10;
  List<SpriteMover> _spriteMovers;
  ElapsedTime _elapsedTime;

  BackgroundTheMatrix({@required this.pegBoard}) {
    _random = Random(DateTime.now().second);
    _sprite = _createSprite();
    _elapsedTime = ElapsedTime(targetMilliseconds: 1000);
    _spriteMovers = List.filled(numSprites, null);
    _createSomeSpriteMovers();
  }

  Sprite _createSprite() {
    return Sprite(pegBoard: pegBoard, spriteElements: <SpriteElement>[
      SpriteElement(Coord(0, 0), Color.fromARGB(255, 0, 50, 0)),
      SpriteElement(Coord(0, 1), Color.fromARGB(255, 0, 90, 0)),
      SpriteElement(Coord(0, 2), Color.fromARGB(255, 0, 110, 0)),
      SpriteElement(Coord(0, 3), Color.fromARGB(255, 0, 140, 0)),
      SpriteElement(Coord(0, 4), Color.fromARGB(255, 0, 170, 0)),
      SpriteElement(Coord(0, 5), Color.fromARGB(255, 0, 230, 0)),
      SpriteElement(Coord(0, 6), Color.fromARGB(255, 0, 255, 0)),
    ]);
  }

  /// Creates a few sprite movers.  This is called at random times to ensure the
  /// sprites are not all created at once.
  void _createSomeSpriteMovers() {
    int index = 0;
    int numCreated = 0;

    for (int i = 0; i < _spriteMovers.length; i++) {
      if (numCreated >= 1) {
        return;
      }

      if (index >= _spriteMovers.length) {
        index = 0;
      }

      if (_spriteMovers[index] == null) {
        _spriteMovers[index] = _createSpriteMover(index);
        numCreated++;
      }

      index++;
    }
  }

  SpriteMover _createSpriteMover(int id) {
    int x = _random.nextInt(PegBoard.pegWidth);
    int y = -(_random.nextInt(3) + 3);

    return SpriteMover(
        spriteList: [_sprite],
        id: id,
        start: Coord(x, y),
        increment: Coord(0, 1),
        frameMs: 300,
        isDone: isDone,
        doneCallback: spriteFinished);
  }

  /// Indicates when a sprite is finished.
  bool isDone(int x, int y) {
    return y >= PegBoard.pegHeight;
  }

  void spriteFinished(int id) {
    _spriteMovers[id] = null;
  }

  void draw() {
    for (int i = 0; i < pegBoard.totalPegs; i++) {
      pegBoard.getPeg(i).pegColor = PegData.blackPeg;
    }

    if (_elapsedTime.timesUp()) {
      _createSomeSpriteMovers();
      _elapsedTime.reset();
    }

    for (int i = 0; i < _spriteMovers.length; i++) {
      if (_spriteMovers[i] != null) {
        _spriteMovers[i].next();
      }
    }
  }
}
