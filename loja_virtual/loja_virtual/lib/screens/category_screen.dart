import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {

  final DocumentSnapshot snapshot; //variavel do tipo snaphot

  CategoryScreen(this.snapshot); //construtor

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // terá duas guias que o usuário escolhe se quser lista ou lado a lado
      child: Scaffold(
        appBar: AppBar(
          title: Text(snapshot.data["title"]),//texto do app bar que será mostrado em cima será o da categoria escolhida.
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white,//cor que a guia selecionada ficará
            tabs: <Widget>[
              Tab(icon: Icon(Icons.grid_on),),
              Tab(icon: Icon(Icons.list),)
            ],
          ),
        ),
        body: TabBarView(//irá mostrar as guias dos Tabs
          physics: NeverScrollableScrollPhysics(), //desativa a passagem de uma guia para outra pelo passar para o lado, força usar os icones
          children: <Widget>[
            Container(color: Colors.blue,),
            Container(color: Colors.yellow),
          ],
        ),
      ),
    );
  }
}
