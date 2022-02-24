import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snake_game/app/widgets/game_controller.dart';

import 'models/point.dart';
import 'models/snake.dart';

class SnackGamePage extends StatefulWidget {
  const SnackGamePage({Key? key}) : super(key: key);

  @override
  State<SnackGamePage> createState() => _SnackGamePageState();
}

class _SnackGamePageState extends State<SnackGamePage> {
  var snake = Snake(Point(15, 15), [], Direction.top);
  late Point apple;
  int squareSize = 0;
  final int tamanho = 20;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    squareSize = screenSize.width ~/ tamanho;
    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: (event) {
        if (event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
          changeDirection(Direction.top);
        }
        if (event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
          changeDirection(Direction.down);
        }
        if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
          changeDirection(Direction.left);
        }
        if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
          changeDirection(Direction.right);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Snack Game Flutter')),
        body: Column(
          children: [
            Text('Score: ${snake.trails.length + 1}'),
            Stack(children: [
              Container(
                color: Colors.black,
                width: (squareSize * 20),
                height: (squareSize * 20),
              ),
              ...squares()
            ]),
            Visibility(
              visible: Platform.isAndroid || Platform.isIOS,
              child: Expanded(
                child: Center(
                  child: GameController(
                    onUp: () => changeDirection(Direction.top),
                    onLeft: () => changeDirection(Direction.left),
                    onRight: () => changeDirection(Direction.right),
                    onDown: () => changeDirection(Direction.down),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void changeDirection(Direction direction) {
    snake.direction = direction;
  }

  Future<void> gameLoop() async {
    await Future.delayed(const Duration(milliseconds: 120));
    verifyEating();
    setState(() {
      organizeSnake();
    });
    gameLoop();
  }

  Point generatePos() {
    var rng = Random();
    return Point(rng.nextInt(19), rng.nextInt(19));
  }

  @override
  void initState() {
    apple = generatePos();
    gameLoop();
    super.initState();
  }

  void organizeSnake() {
    final firstTrail = snake.point;
    switch (snake.direction) {
      case Direction.top:
        snake.point = Point(snake.point.x, snake.point.y - 1);
        break;
      case Direction.down:
        snake.point = Point(snake.point.x, snake.point.y + 1);
        break;
      case Direction.right:
        snake.point = Point(snake.point.x + 1, snake.point.y);
        break;
      case Direction.left:
        snake.point = Point(snake.point.x - 1, snake.point.y);
        break;
    }
    final newTrails = <Point>[];
    for (var i = 0; i < snake.trails.length; i++) {
      if (i == 0) {
        newTrails.add(firstTrail);
      } else {
        newTrails.add(Point(snake.trails[i - 1].x, snake.trails[i - 1].y));
      }
    }
    snake.trails = newTrails;

    if (snake.point.x * squareSize >= squareSize * tamanho) {
      snake.point = Point(0, snake.point.y);
    }

    if (snake.point.y * squareSize >= squareSize * tamanho) {
      snake.point = Point(snake.point.x, 0);
    }

    if (snake.point.x * squareSize < 0) {
      snake.point = Point(tamanho - 1, snake.point.y);
    }
    if (snake.point.y * squareSize < 0) {
      snake.point = Point(snake.point.x, tamanho - 1);
    }
  }

  Widget square(int x, int y, [Color color = Colors.white]) {
    return Positioned(
      top: (y * squareSize).toDouble(),
      left: (x * squareSize).toDouble(),
      child: Container(
        color: color,
        width: squareSize.toDouble(),
        height: squareSize.toDouble(),
      ),
    );
  }

  List<Widget> squares() {
    final squares = <Widget>[];
    squares.add(square(apple.x, apple.y, Colors.pink));
    squares.add(square(snake.point.x, snake.point.y));

    int count = 0;
    for (var trail in snake.trails) {
      squares.add(square(trail.x, trail.y, Colors.green[700]!));
      count++;
    }

    return squares;
  }

  void verifyEating() {
    if (snake.point == apple) {
      snake.trails.add(apple);
      apple = generatePos();
    }
  }
}
