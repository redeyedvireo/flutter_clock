class Coord {
  final int x, y;

  Coord(this.x, this.y);

  Coord operator +(Coord c) => Coord(x + c.x, y + c.y);
}
