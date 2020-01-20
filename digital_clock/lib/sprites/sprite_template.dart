import 'package:flutter/material.dart';

import '../peg_board.dart';
import '../coord.dart';
import 'sprite.dart';

class SpriteTemplateElement {
  Coord coord;
  int colorIndex;

  SpriteTemplateElement(this.coord, this.colorIndex);
}

class SpriteTemplate {
  List<SpriteTemplateElement> spriteTemplateElements;
  PegBoard pegBoard;

  SpriteTemplate(
      {@required this.pegBoard, @required this.spriteTemplateElements});

  static SpriteTemplate fromMap(
      PegBoard pegBoard, int width, int height, List<int> templateMap) {
    List<SpriteTemplateElement> templateElements = [];

    int dataOffset = 0;
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        if (templateMap[dataOffset] != -1) {
          templateElements
              .add(SpriteTemplateElement(Coord(x, y), templateMap[dataOffset]));
        }

        dataOffset++;
      }
    }

    return SpriteTemplate(
        pegBoard: pegBoard, spriteTemplateElements: templateElements);
  }

  Sprite renderSprite(List<Color> colors) {
    List<SpriteElement> spriteElements = [];

    spriteTemplateElements.forEach((spriteTemplateElement) {
      final color = spriteTemplateElement.colorIndex < colors.length
          ? colors[spriteTemplateElement.colorIndex]
          : Colors.white;
      spriteElements.add(SpriteElement(spriteTemplateElement.coord, color));
    });

    return Sprite(pegBoard: pegBoard, spriteElements: spriteElements);
  }
}
