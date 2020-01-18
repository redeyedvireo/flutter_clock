import 'package:flutter/material.dart';

import 'peg_board.dart';
import 'coord.dart';


/// A single peg of a sprite.  The x, y coordinates are local coordinates.
class SpriteElement {
  Coord coord;
  Color color;

  SpriteElement(this.coord, this.color);
}


class Sprite {
  List<SpriteElement> spriteElements;
  PegBoard pegBoard;

  Sprite({@required this.pegBoard, @required this.spriteElements});

  /// Draws the sprite with its upper-left corner at x, y.
  void draw(int x, int y) {
    final spritePos = Coord(x, y);

    spriteElements.forEach((spriteElement) {
      final pegBoardPos = spriteElement.coord + spritePos;
      final pegId = pegBoard.pegIdCoord(pegBoardPos);

      if (pegId >= 0 && pegId <= PegBoard.maxPegId) {
        pegBoard.getPeg(pegId).pegColor = spriteElement.color;
      }
    });
  }
}