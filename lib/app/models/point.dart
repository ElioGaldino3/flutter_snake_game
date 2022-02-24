class Point {
  int x;
  int y;
  
  Point(
    this.x,
    this.y,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Point &&
      other.x == x &&
      other.y == y;
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}
