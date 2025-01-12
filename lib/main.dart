import 'package:flutter/material.dart';
import 'screen1.dart';
//import 'screen2.dart';

void main() {
  runApp(const ShelfScoutApp());
}

class ShelfScoutApp extends StatelessWidget {
  const ShelfScoutApp({super.key});

  get title => null;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shelf Scout',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: const Screen1(),
    );
  }
}
