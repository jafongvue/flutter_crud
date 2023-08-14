import 'package:flutter/material.dart';
import 'package:flutter_basic_crud/pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //ລືມດີບາອອກ
      title: 'Flutter Crud',
      home: Home(),
    );
  }
}
