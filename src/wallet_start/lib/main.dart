import 'package:flutter/material.dart';
import 'package:wallet/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'INFINITAS',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
