import 'package:flutter/material.dart';

import 'field.dart';
import 'game.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Sandbox',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Game(),
      ),
    );
  }
}

final generatedField =
    List.generate(8, (columnIndex) => List.generate(20, (rowIndex) => true));
