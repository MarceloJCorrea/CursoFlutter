import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance.collection('products').getDocuments(),//carrega a lista de produtos do firebase
      builder: (context, snapshot){//função obrigatoria para buscar os dados firebase
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator(),);//se não retornar nada na consulta vai ficar com a bolinha rodando
        } else {
          return
              ListView(

              );
        }
      },
    );
  }
}
