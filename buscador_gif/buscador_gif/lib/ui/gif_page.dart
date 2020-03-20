import 'package:share/share.dart';
import 'package:flutter/material.dart';

class GifPage extends StatelessWidget {//stateless porque não interage com o usuário

  final Map _gifData;//declara o construtor

  GifPage(this._gifData);//recebe o dado do construtor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(//barra com o titulo do gif
        title: Text(_gifData['title']),
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: (){
              Share.share(_gifData['images']['original']['url']);
            },
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(//centraliza o gif na tela
        child: Image.network(_gifData['images']['fixed_height']['url']),//image no centro
      )
    );
  }
}


