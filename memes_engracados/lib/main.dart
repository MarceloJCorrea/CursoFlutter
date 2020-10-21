import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'file:///D:/Estudar/Flutter/apps/memes_engracados/lib/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());

  /*Firestore.instance.collection('col').document('doc').setData({"texto": "daniel"});*/
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memes engraçados',
      theme: ThemeData(
        primaryColor: Colors.orange
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}


