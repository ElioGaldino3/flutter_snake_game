import 'package:snake_game/app/models/point.dart';

class Snake {
  Point point;
  List<Point> trails;
  Direction direction;

  Snake(
    this.point,
    this.trails,
    this.direction
  );
}

enum Direction { top, left, right, down }
