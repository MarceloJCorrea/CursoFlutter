import 'package:flutter/material.dart';
import 'package:gerenteloja/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Gerente Loja',
        theme: ThemeData(
          primaryColor: Colors.pinkAccent,
        ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
