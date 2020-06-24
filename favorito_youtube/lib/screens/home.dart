import 'package:favoritoyoutube/delegate/data_search.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 25,
          child: Image.asset('images/logo.png'),
        ),
        elevation: 0,
        backgroundColor: Colors.black87,
        actions: <Widget>[
          Align(//para que o texto fique alinhado ao centro
            alignment: Alignment.center,
            child: Text('0', style: TextStyle(fontSize: 10,),),
          ),
          IconButton(//icone da estrela - favorito
            icon: Icon(Icons.star),
            onPressed: (){},
          ),
          IconButton(//icone da pesquisa
            icon: Icon(Icons.search),
            onPressed: () async{
              String result = await showSearch(context: context, delegate: DataSearch());//pega o resultado do dataSearch
            },
          ),
        ],
      ),
      body: Container(),
    );
  }
}
