import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/tiles/category_tile.dart';

class ProductsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance.collection("products").getDocuments(),//carrega a lista de produtos do firebase
      builder: (context, snapshot){//função obrigatoria para buscar os dados firebase
        if(!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),//se não retornar nada na consulta vai ficar com a bolinha rodando
          );
        else {
          var dividedTiles = //pega a listTiles e pede para dividir as tiles
          ListTile.divideTiles(tiles: snapshot.data.documents.map((doc){//pega cada documento e torca cada categorytile e passa todas as tiles para o divideTiles e transforma tudo em uma lista
               return CategoryTile(doc);//
              }).toList(),
              color: Colors.grey[500]).toList();//cor do divisor entre as Categorias, transforma em list depois

          return ListView(
            children: dividedTiles,
          );
        }
      },
    );
  }
}
