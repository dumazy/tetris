import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'field.dart';
import 'game_controller.dart';

class Game extends StatefulWidget {
  const Game({Key? key}) : super(key: key);

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  late GameController _controller;

  @override
  void initState() {
    super.initState();
    _controller = GameController();
  }

  @override
  Widget build(BuildContext context) {
    return ControllerShortcuts(
      controller: _controller,
      child: StreamBuilder<GameState>(
        stream: _controller.gameStateStream,
        initialData: _controller.gameState,
        builder: (context, snapshot) {
          final state = snapshot.data!;
          return PausedOverlay(
            isPaused: state.isPaused,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Field(
                matrix: state.totalMatrix,
              ),
            ),
          );
        },
      ),
    );
  }
}

class ControllerShortcuts extends StatelessWidget {
  final GameController controller;
  final Widget child;
  ControllerShortcuts({Key? key, required this.child, required this.controller})
      : super(key: key);

  final moveLeftSet = LogicalKeySet(
    LogicalKeyboardKey.arrowLeft,
  );
  final moveRightSet = LogicalKeySet(
    LogicalKeyboardKey.arrowRight,
  );
  final rotateSet = LogicalKeySet(
    LogicalKeyboardKey.arrowUp,
  );
  final moveDownSet = LogicalKeySet(
    LogicalKeyboardKey.arrowDown,
  );
  final togglePauseSet = LogicalKeySet(
    LogicalKeyboardKey.space,
  );

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        moveLeftSet: MoveLeftIntent(),
        moveRightSet: MoveRightIntent(),
        rotateSet: RotateIntent(),
        moveDownSet: MoveDownIntent(),
        togglePauseSet: TogglePauseIntent(),
      },
      child: Actions(
        actions: {
          MoveLeftIntent:
              CallbackAction(onInvoke: (intent) => controller.moveLeft()),
          MoveRightIntent:
              CallbackAction(onInvoke: (intent) => controller.moveRight()),
          RotateIntent:
              CallbackAction(onInvoke: (intent) => controller.rotate()),
          MoveDownIntent:
              CallbackAction(onInvoke: (intent) => controller.moveDown()),
          TogglePauseIntent:
              CallbackAction(onInvoke: (intent) => controller.togglePause()),
        },
        child: Focus(
          autofocus: true,
          child: child,
        ),
      ),
    );
  }
}

class MoveLeftIntent extends Intent {}

class MoveRightIntent extends Intent {}

class RotateIntent extends Intent {}

class MoveDownIntent extends Intent {}

class TogglePauseIntent extends Intent {}

class PausedOverlay extends StatelessWidget {
  final bool isPaused;
  final Widget child;
  const PausedOverlay({
    Key? key,
    required this.isPaused,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      alignment: Alignment.center,
      children: [
        child,
        if (isPaused)
          Container(
            color: Colors.black12,
            child: Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(
                    60,
                  ),
                ),
                child: Center(
                  child: Text(
                    'Press SPACE to play',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
