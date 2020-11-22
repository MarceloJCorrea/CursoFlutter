import 'package:flutter/material.dart';

class FavoriteTab extends StatefulWidget {
  @override
  _FavoriteTabState createState() => _FavoriteTabState();
}

class _FavoriteTabState extends State<FavoriteTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text('Você ainda não possui favoritos', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),),
    );
  }
}

