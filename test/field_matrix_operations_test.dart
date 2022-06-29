import 'package:flutter_tetris/field_matrix.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FieldMatrixOperations', () {
    group('rotate', () {
      test('should rotate 2x2 matrix', () {
        final matrix = [
          [true, false],
          [true, true],
        ];
        final expected = [
          [true, true],
          [true, false],
        ];

        final result = matrix.rotate();
        expect(result, expected);
      });

      test('should rotate 3x3 matrix', () {
        final matrix = [
          [true, false, true],
          [true, true, false],
          [false, true, false],
        ];
        final expected = [
          [false, true, true],
          [true, true, false],
          [false, false, true],
        ];

        final result = matrix.rotate();
        expect(result, expected);
      });

      test('should rotate 2x3 matrix', () {
        final matrix = [
          [true, false, true],
          [true, true, false],
        ];
        final expected = [
          [true, true],
          [true, false],
          [false, true],
        ];

        final result = matrix.rotate();
        expect(result, expected);
      });

      test('should rotate 2x3 matrix twice', () {
        final matrix = [
          [true, false, true],
          [true, true, false],
        ];
        final expected = [
          [false, true, true],
          [true, false, true],
        ];

        final result = matrix.rotate(2);
        expect(result, expected);
      });

      test('should return same 3x3 matrix after 4 rotations', () {
        final matrix = [
          [true, false, true],
          [true, true, false],
          [false, true, false],
        ];

        final result = matrix.rotate(4);
        expect(result, matrix);
      });
    });
  });
}
