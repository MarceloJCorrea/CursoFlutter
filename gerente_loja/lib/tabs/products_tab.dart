import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerenteloja/tile/category_tile.dart';

class ProductsTab extends StatefulWidget {
  @override
  _ProductsTabState createState() => _ProductsTabState();
}

class _ProductsTabState extends State<ProductsTab> with AutomaticKeepAliveClientMixin  {//deixa a janela viva mesmo que saia da tab
  @override
  Widget build(BuildContext context) {
    super.build(context);//quando usar o AutomaticKeepAliveClientMixin tem que por o super

    return StreamBuilder<QuerySnapshot>(//streambuilder garante que os dados sejam atualizados em tempo real
      stream: Firestore.instance.collection('products').snapshots(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return Center(child:
          CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.pinkAccent),),
          );
        }
        return ListView.builder(
            itemCount: snapshot.data.documents.length, //tamanho da lista que vem do firebase
            itemBuilder: (context, index){
              return CategoryTile(snapshot.data.documents[index]);
            }
        );
      }
    );
  }

  @override
  bool get wantKeepAlive => true;//vai manter a janela viva
}
