import 'dart:async';

import 'config.dart';
import 'field_matrix.dart';
import 'model/blocks.dart';

const _cycleDuration = Duration(seconds: 1);

class GameController {
  GameState _gameState = GameState(
    fixedMatrix: generateEmptyMatrix(numberOfRows, numberOfColumns),
    isPaused: true,
  );
  StreamController<GameState> _controller = StreamController.broadcast();

  GameState get gameState => _gameState;
  Stream<GameState> get gameStateStream => _controller.stream;

  StreamSubscription? _updateStream;

  void _start() {
    final state = GameState(
      fixedMatrix: _gameState.fixedMatrix,
      block: _gameState.block,
      isPaused: false,
    );
    _gameState = state;
    _controller.add(_gameState);
    if (_updateStream == null) {
      _updateStream = Stream.periodic(_cycleDuration).listen((_) {
        if (_gameState.block == null) {
          final block = _generateBlock();
          _updateBlockState(block);
        } else {
          _updateBlockState(_gameState.block!.moveDown());
        }
      });
    } else {
      _updateStream!.resume();
    }
  }

  void _pause() {
    _updateStream?.pause();
    final state = GameState(
      fixedMatrix: _gameState.fixedMatrix,
      block: _gameState.block,
      isPaused: true,
    );
    _gameState = state;
    _controller.add(_gameState);
  }

  void togglePause() {
    _gameState.isPaused ? _start() : _pause();
  }

  void _updateBlockState(Block block) {
    GameState state;
    if (block.bottomCollision(_gameState.fixedMatrix)) {
      state = GameState(
        fixedMatrix: _gameState.fixedMatrix.insertMatrix(
          block.matrix,
          block.offsetLeft,
          block.offsetTop,
        ),
        isPaused: _gameState.isPaused,
        block: null,
      );
    } else {
      state = GameState(
        fixedMatrix: _gameState.fixedMatrix,
        isPaused: _gameState.isPaused,
        block: block,
      );
    }
    _gameState = state;
    _controller.add(_gameState);
  }

  void moveLeft() {
    if (_gameState.isPaused) {
      return;
    }
    final block = _gameState.block;
    if (block == null) {
      return;
    }
    if (block.leftCollision(_gameState.fixedMatrix)) {
      return;
    }
    _updateBlockState(block.moveLeft());
  }

  void moveRight() {
    if (_gameState.isPaused) {
      return;
    }
    final block = _gameState.block;
    if (block == null) {
      return;
    }
    if (block.rightCollision(_gameState.fixedMatrix)) {
      return;
    }
    _updateBlockState(block.moveRight());
  }

  void rotate() {
    if (_gameState.isPaused) {
      return;
    }
    final block = _gameState.block;
    if (block == null) {
      return;
    }
    final rotatedBlock = block.rotate();

    final fieldMatrix = _gameState.fixedMatrix;
    if (rotatedBlock.centerCollision(fieldMatrix)) {
      return;
    }
    _updateBlockState(rotatedBlock);
  }

  void moveDown() {
    if (_gameState.isPaused) {
      return;
    }
    final block = _gameState.block;
    if (block == null) {
      return;
    }
    if (block.bottomCollision(_gameState.fixedMatrix)) {
      return;
    }
    _updateBlockState(block.moveDown());
  }

  Block _generateBlock() {
    final initialOffset = (numberOfColumns ~/ 2) - 1;
    return Block.randomBlock(offsetLeft: initialOffset);
  }
}

class GameState {
  final FieldMatrix fixedMatrix;
  final bool isPaused;
  final Block? block;

  GameState({
    required this.fixedMatrix,
    required this.isPaused,
    this.block,
  });

  FieldMatrix get totalMatrix => block == null
      ? fixedMatrix
      : fixedMatrix.insertMatrix(
          block!.matrix,
          block!.offsetLeft,
          block!.offsetTop,
        );
}
