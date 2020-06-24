import 'package:favoritoyoutube/screens/home.dart';
import 'package:flutter/material.dart';
import 'api.dart';

void main() {

  Api api = Api();
  api.search('palmeiras');

  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Home()
    );
  }
}