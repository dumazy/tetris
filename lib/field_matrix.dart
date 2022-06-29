/// [row][column]
typedef FieldMatrix = List<List<bool>>;

FieldMatrix generateEmptyMatrix(int rows, int columns) {
  return List.generate(rows, (index) => List.generate(columns, (_) => false));
}

extension FieldMatrixOperations on FieldMatrix {
  int get rows => this.length;
  int get columns => this.first.length;

  FieldMatrix copy() {
    return List.generate(
        this.length,
        (rowIndex) => List.generate(
            this.first.length, (columnIndex) => this[rowIndex][columnIndex]));
  }

  FieldMatrix rotate([int rotations = 1]) {
    if (rotations < 1) {
      return this;
    }
    // initialize empty matrix switching row and column length
    final newMatrix = List.generate(
        this.first.length, (_) => List.generate(this.length, (_) => false));

    // flip over major diagonal
    for (int rowIndex = 0; rowIndex < this.length; rowIndex++) {
      for (int columnIndex = 0;
          columnIndex < this.first.length;
          columnIndex++) {
        newMatrix[columnIndex][rowIndex] = this[rowIndex][columnIndex];
      }
    }

    // reverse rows;
    return newMatrix
        .map((row) => row.reversed.toList())
        .toList()
        .rotate(--rotations);
  }

  FieldMatrix insertMatrix(
    FieldMatrix matrix, [
    int offsetLeft = 0,
    int offsetTop = 0,
  ]) {
    final newMatrix = this.copy();
    for (int rowIndex = 0; rowIndex < this.length; rowIndex++) {
      for (int columnIndex = 0;
          columnIndex < this.first.length;
          columnIndex++) {
        final withinRow =
            rowIndex >= offsetTop && rowIndex < offsetTop + matrix.rows;
        final withinColumn = columnIndex >= offsetLeft &&
            columnIndex < offsetLeft + matrix.columns;
        if (withinRow &&
            withinColumn &&
            matrix[rowIndex - offsetTop][columnIndex - offsetLeft]) {
          newMatrix[rowIndex][columnIndex] = true;
        }
      }
    }
    return newMatrix;
  }

  bool get bottomFrameCollision => this.last.contains(true);

  bool bottomCollision(FieldMatrix matrix) {
    for (int rowIndex = 1; rowIndex < this.length; rowIndex++) {
      for (int columnIndex = 0;
          columnIndex < this.first.length;
          columnIndex++) {
        if (this[rowIndex - 1][columnIndex] && matrix[rowIndex][columnIndex]) {
          return true;
        }
      }
    }
    return false;
  }

  FieldMatrix moveDown() {
    final newMatrix = this.copy();
    newMatrix.removeLast();
    newMatrix.insert(0, List.generate(this.first.length, (_) => false));
    return newMatrix;
  }

  FieldMatrix moveLeft() {
    final newMatrix = this.copy();
    forEachCell((rowIndex, columnIndex) {
      if (columnIndex != 0) {
        newMatrix[rowIndex][columnIndex - 1] = this[rowIndex][columnIndex];
      }
    });
    newMatrix.forEachCell((rowIndex, columnIndex) {
      if (columnIndex == newMatrix.columns - 1) {
        newMatrix[rowIndex][columnIndex] = false;
      }
    });
    return newMatrix;
  }

  bool get rightFrameCollision {
    return this.any((row) => row.last);
  }

  bool get leftFrameCollision {
    return this.any((row) => row.first);
  }

  void forEachCell(void Function(int rowIndex, int columnIndex) block) {
    for (int rowIndex = 0; rowIndex < this.length; rowIndex++) {
      for (int columnIndex = 0;
          columnIndex < this.first.length;
          columnIndex++) {
        block(rowIndex, columnIndex);
      }
    }
  }
}
