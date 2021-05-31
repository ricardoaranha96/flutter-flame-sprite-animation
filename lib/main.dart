import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/material.dart';

void main() {
  final game = new MyGame();
  runApp(GameWidget(game: game));
}

class MyGame extends Game with TapDetector {
  int robotDirection = 1;
  late SpriteAnimation runningRobot;
  late SpriteAnimationComponent runningRobotComponent;
  late Vector2 robotPosition;
  static const double robotWidth = 48;
  final robotSize = Vector2(robotWidth, 60);

  late Sprite pressedButton;
  late Sprite unpressedButton;

  late Vector2 buttonPosition;
  final buttonSize = Vector2(120, 30);

  bool isPressed = false;

  Future<void> onLoad() async {
    robotPosition = Vector2(size.x / 2 - robotWidth / 2, 50);
    buttonPosition = Vector2(size.x / 2 - 60, 120);

    runningRobot = await loadSpriteAnimation(
        'robot.png',
        SpriteAnimationData.sequenced(
            amount: 8, textureSize: Vector2(16, 18), stepTime: 0.1));

    runningRobotComponent = SpriteAnimationComponent(animation: runningRobot);
    runningRobotComponent.renderFlipX = true;

    unpressedButton = await loadSprite('buttons.png',
        srcPosition: Vector2(0, 0), srcSize: Vector2(60, 20));
    pressedButton = await loadSprite('buttons.png',
        srcPosition: Vector2(0, 20), srcSize: Vector2(60, 20));
  }

  render(Canvas canvas) {
    runningRobot
        .getSprite()
        .render(canvas, position: robotPosition, size: robotSize);

    final button = isPressed ? pressedButton : unpressedButton;
    button.render(canvas, position: buttonPosition, size: buttonSize);
  }

  update(double dt) {
    if (isPressed) {
      if ((robotPosition.x + robotWidth) >= size.x) {
        robotDirection = -1;
      } else if (robotPosition.x <= 0) {
        robotDirection = 1;
      }
      robotPosition.setValues(
          robotPosition.x + robotDirection, robotPosition.y);

      runningRobot.update(dt);
    }
  }

  Color backgroundColor() => const Color(0xFF222222);

  void onTapDown(TapDownInfo event) {
    final buttonArea = buttonPosition & buttonSize;

    isPressed = buttonArea.contains(event.eventPosition.game.toOffset());
  }

  void onTapUp(TapUpInfo event) {
    isPressed = false;
  }

  void onTapCancel() {
    isPressed = false;
  }
}
