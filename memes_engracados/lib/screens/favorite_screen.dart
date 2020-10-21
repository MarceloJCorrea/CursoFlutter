import 'package:flutter/material.dart';

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favoritos'),centerTitle: true,),
      body: Container(
        alignment: Alignment.center,
        child: Text('Você ainda não possui favoritos', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),),
      ),
    );
  }
}
