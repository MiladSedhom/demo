import 'package:flutter/material.dart';
import 'package:demo/screens/home.dart';

void main() {
  runApp(MaterialApp(
    home: const Home(),
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color.fromARGB(255, 48, 194, 175),

        // ···
      ),
    ),
  ));
}
