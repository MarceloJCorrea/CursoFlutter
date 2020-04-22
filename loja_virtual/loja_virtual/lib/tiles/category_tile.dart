import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {

  final DocumentSnapshot snapshot;//declara variavel que irá receber os dados do firesore

  CategoryTile(this.snapshot);//declara o construtor

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25.0,//raio do ícone
        backgroundColor: Colors.transparent,//cor de fundo transparente do icone
        backgroundImage: NetworkImage(snapshot.data["icon"]),//icone que será carregado do firestore
      ),
      title: Text(snapshot.data["title"]),//titulo que será carregado do firestore
      trailing: Icon(Icons.keyboard_arrow_right),//seta do final para indicar para entrar para ver os produtos
      onTap: (){},
    );
  }
}
