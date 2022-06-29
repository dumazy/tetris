import 'dart:math';

import 'package:flutter/foundation.dart';

import '../field_matrix.dart';

@immutable
class Block {
  static final random = Random();

  final FieldMatrix matrix;
  final int offsetLeft;
  final int offsetTop;

  int get rows => matrix.length;
  int get columns => matrix.first.length;

  Block._(this.matrix, this.offsetLeft, this.offsetTop);

  factory Block.randomBlock({int offsetLeft = 0, int offsetTop = 0}) {
    switch (random.nextInt(7)) {
      case 6:
        return Block._t();
      case 5:
        return Block._i();
      case 4:
        return Block._sLeft();
      case 3:
        return Block._sRight();
      case 2:
        return Block._lLeft();
      case 1:
        return Block._lRight();
      case 0:
      default:
        return Block._square();
    }
  }

  Block moveLeft() {
    return Block._(matrix, offsetLeft - 1, offsetTop);
  }

  Block moveRight() {
    return Block._(matrix, offsetLeft + 1, offsetTop);
  }

  Block moveDown() {
    return Block._(matrix, offsetLeft, offsetTop + 1);
  }

  Block rotate() {
    return Block._(matrix.rotate(), offsetLeft, offsetTop);
  }

  bool centerCollision(FieldMatrix matrix) {
    var hasCollision = false;
    this.matrix.forEachCell((rowIndex, columnIndex) {
      if (this.matrix[rowIndex][columnIndex] &&
          matrix[offsetTop + rowIndex][offsetLeft + columnIndex]) {
        hasCollision = true;
      }
    });
    return hasCollision;
  }

  bool bottomCollision(FieldMatrix matrix) {
    // frame collision
    if (offsetTop + rows >= matrix.rows) {
      return true;
    }

    // field collision
    var hasCollision = false;
    this.matrix.forEachCell((rowIndex, columnIndex) {
      if (this.matrix[rowIndex][columnIndex] &&
          matrix[offsetTop + rowIndex + 1][offsetLeft + columnIndex]) {
        hasCollision = true;
      }
    });
    return hasCollision;
  }

  bool leftCollision(FieldMatrix matrix) {
    // frame collision
    if (offsetLeft <= 0) {
      return true;
    }

    // field collision
    var hasCollision = false;
    this.matrix.forEachCell((rowIndex, columnIndex) {
      if (this.matrix[rowIndex][columnIndex] &&
          matrix[offsetTop + rowIndex][offsetLeft + columnIndex - 1]) {
        hasCollision = true;
      }
    });
    return hasCollision;
  }

  bool rightCollision(FieldMatrix matrix) {
    // frame collision
    if (offsetLeft + columns >= matrix.columns) {
      return true;
    }

    // field collision
    var hasCollision = false;
    this.matrix.forEachCell((rowIndex, columnIndex) {
      if (this.matrix[rowIndex][columnIndex] &&
          matrix[offsetTop + rowIndex][offsetLeft + columnIndex + 1]) {
        hasCollision = true;
      }
    });
    return hasCollision;
  }

  factory Block._t({int offsetLeft = 0, int offsetTop = 0}) {
    const matrix = [
      [true, true, true],
      [false, true, false],
    ];
    final rotations = Block.random.nextInt(4);
    return Block._(matrix.rotate(rotations), offsetLeft, offsetTop);
  }

  factory Block._i({int offsetLeft = 0, int offsetTop = 0}) {
    const matrix = [
      [true, true, true, true]
    ];
    final rotations = Block.random.nextInt(2);
    return Block._(matrix.rotate(rotations), offsetLeft, offsetTop);
  }

  factory Block._sLeft({int offsetLeft = 0, int offsetTop = 0}) {
    const matrix = [
      [true, true, false],
      [false, true, true],
    ];
    final rotations = Block.random.nextInt(4);
    return Block._(matrix.rotate(rotations), offsetLeft, offsetTop);
  }

  factory Block._sRight({int offsetLeft = 0, int offsetTop = 0}) {
    const matrix = [
      [false, true, true],
      [true, true, false],
    ];
    final rotations = Block.random.nextInt(4);
    return Block._(matrix.rotate(rotations), offsetLeft, offsetTop);
  }

  factory Block._lLeft({int offsetLeft = 0, int offsetTop = 0}) {
    const matrix = [
      [true, true, true],
      [false, false, true],
    ];
    final rotations = Block.random.nextInt(4);
    return Block._(matrix.rotate(rotations), offsetLeft, offsetTop);
  }

  factory Block._lRight({int offsetLeft = 0, int offsetTop = 0}) {
    const matrix = [
      [false, false, true],
      [true, true, true],
    ];
    final rotations = Block.random.nextInt(4);
    return Block._(matrix.rotate(rotations), offsetLeft, offsetTop);
  }

  factory Block._square({int offsetLeft = 0, int offsetTop = 0}) {
    const matrix = [
      [true, true],
      [true, true]
    ];
    return Block._(matrix, offsetLeft, offsetTop);
  }
}
