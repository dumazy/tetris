import 'package:flutter/material.dart';

import 'config.dart';

const _borderColor = Colors.black;
const _separatorColor = Colors.black45;
const _separatorWidth = 1.0;
const _emptyColor = Colors.white;
const _filledColor = Colors.orange;

typedef FieldMatrix = List<List<bool>>;

class Field extends StatelessWidget {
  final FieldMatrix matrix;

  const Field({Key? key, required this.matrix}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: numberOfColumns / numberOfRows,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: _borderColor,
          ),
        ),
        child: CellBuilder(
          builder: (_, columnIndex, rowIndex) {
            return Container(
              color: matrix[rowIndex][columnIndex] ? _filledColor : _emptyColor,
            );
          },
          width: numberOfColumns,
          height: numberOfRows,
        ),
      ),
    );
  }
}

typedef CellWidgetBuilder = Widget Function(BuildContext, int, int);

class CellBuilder extends StatelessWidget {
  final CellWidgetBuilder builder;
  final int width;
  final int height;

  const CellBuilder({
    Key? key,
    required this.builder,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: width,
        mainAxisSpacing: _separatorWidth,
        crossAxisSpacing: _separatorWidth,
      ),
      itemCount: width * height,
      itemBuilder: (_, index) {
        final rowIndex = index ~/ width;
        final columnIndex = index % width;
        return builder(context, columnIndex, rowIndex);
      },
    );
  }
}
