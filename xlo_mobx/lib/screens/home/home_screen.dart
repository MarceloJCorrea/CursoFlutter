import 'package:flutter/material.dart';
import 'package:xlomobx/components/custom_drawer/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(//para colocar a delimitação no inicío da barra
       child: Scaffold(
        drawer: CustomDrawer(),
        appBar: AppBar(),
      ),
    );
  }
}
