import 'package:flutter/material.dart';
import 'dart:math';

import '../peg_board.dart';
import '../peg_data.dart';
import '../coord.dart';
import '../sprites/sprite.dart';
import '../sprites/sprite_mover.dart';
import '../sprites/sprite_template.dart';
import '../sprites/fish_template.dart';
import '../elapsed_time.dart';
import '../color_fader.dart';

import 'background_manager.dart';


class BackgroundAquarium implements IBackground {
  PegBoard pegBoard;
  Random _random;
  ColorFader colorFader;
  static int blueDelta = 10;
  static int startColor = 110;
  int topRowColor;

  static int numSprites = 3;
  int numTemplates = 0;
  List<SpriteMover> _spriteMovers;
  ElapsedTime _elapsedTime;

  List<SpriteTemplate> _spriteTemplates = [];

  BackgroundAquarium({@required this.pegBoard}) {
    _random = Random(DateTime.now().second);
    topRowColor = (PegBoard.pegHeight - startColor) ~/ blueDelta;
    colorFader = ColorFader(startColor: Color.fromARGB(255, 0, 0, startColor), redDelta: 0, blueDelta: 10, greenDelta: 0);

    _addSpriteTemplate(14, 8, fishTemplateMap);
    _addSpriteTemplate(12, 5, fish2TemplateMap);
    _addSpriteTemplate(8, 5, fish3TemplateMap);
    _addSpriteTemplate(7, 4, fish4TemplateMap);
    _addSpriteTemplate(14, 6, sharkTemplateMap);

    _elapsedTime = ElapsedTime(targetMilliseconds: 7000);
    _spriteMovers = List.filled(numSprites, null);

    _createSomeSpriteMovers();
  }

  void _addSpriteTemplate(int width, int height, templateMap) {
    _spriteTemplates.add(SpriteTemplate.fromMap(pegBoard, width, height, templateMap));
    numTemplates++;
    
  }
  
  Sprite _createSprite(SpriteTemplate spriteTemplate) {
    final mainColor = pegBoard.randomBrightColor(1.0);
    final stripeColor = Color.fromARGB(255, mainColor.blue, mainColor.red, mainColor.green);
    final eyeColor = Color.fromARGB(255, mainColor.green, mainColor.blue, mainColor.red);

    List<Color> colors = [
      mainColor,
      stripeColor,
      eyeColor
    ];

    return spriteTemplate.renderSprite(colors);
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
    int x = -10;
    int y = _random.nextInt(9) + 1;

    final spriteTemplateIndex = _random.nextInt(numTemplates);
    final sprite = _createSprite(_spriteTemplates[spriteTemplateIndex]);

    return SpriteMover(spriteList: [sprite],
        id: id,
        start: Coord(x, y),
        increment: Coord(1, 0),
        frameMs: 200,
        isDone: isDone,
        doneCallback: spriteFinished);
  }

  /// Indicates when a sprite is finished.
  bool isDone(int x, int y) {
    return x >= PegBoard.pegWidth;
  }

  void spriteFinished(int id) {
    _spriteMovers[id] = null;
  }

  @override
  void draw() {
    pegBoard.fillPegAreaWithColorFader(0, 0, PegBoard.pegWidth, PegBoard.pegHeight, colorFader);

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