import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {

  final String orderId;

  OrderTile(this.orderId);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.0 , horizontal: 8.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: StreamBuilder<DocumentSnapshot>(//fica monitorando o banco de dados e atualiza a tela instantaneamete caso haja alteração no banco
          stream: Firestore.instance.collection('orders').document(orderId).snapshots(),
          builder: (context, snapshot){
            if(!snapshot.hasData)
              return Center(child: CircularProgressIndicator(),);
            else {
              int status = snapshot.data['status'];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Código do pedido: ${snapshot.data.documentID}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4.0,),
                  Text(_buildProductsText(snapshot.data)),
                  SizedBox(height: 4.0,),
                  Text(
                    'Status do Pedido',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,//da uma espaçamento entre os status
                    children: <Widget>[
                      _buildCircle('1', 'Preparação', status, 1),
                      Container(//uma linha separando os status na Row
                        height: 1.0,
                        width: 40.0,
                        color: Colors.grey[500],
                      ),
                      _buildCircle('2', 'Transporte', status, 2),
                      Container(//uma linha separando os status na Row
                        height: 1.0,
                        width: 40.0,
                        color: Colors.grey[500],
                      ),
                      _buildCircle('3', 'Entrega', status, 3),
                    ],
                  )
                ],
              );
            }
          },
        ),
      )
    );
  }

  String _buildProductsText(DocumentSnapshot snapshot){
    String text = "Descrição: \n";
    for(LinkedHashMap p in snapshot.data['products']){//lista do Firestore é uma linkedhashmap, para cada um dos nossos produtos do pedido vai juntar um texto no outro
      text += '${p['quantity']} x ${p["productData"]["title"]} (R\$ ${p["productData"] ['price'].toStringAsFixed(2)})\n';//para cada um dos produtos vai aparecer a quantitade x o produto e o valor convertido em duas casas
    }
    text += 'Total: R\$ ${snapshot.data['totalPrice'].toStringAsFixed(2)}';//mostra o total do pedido
    return text;
  }

  Widget _buildCircle(String title, String subtitle, int status, int thisStatus){

    Color backColor;//variavel para mudar cor de acordo com status
    Widget child; //variavel para mudar o filho do CircleAvatar de acordo com o status

    if(status < thisStatus){//se o mesmo status é 1 e estou no 2 quer dizer que não chegou ainda no status e deve ficar com a cor cinzinha
      backColor = Colors.grey[500];
      child = Text(title, style: TextStyle(color: Colors.white),);
    }else if(status == thisStatus){//se o status é 2 e estou no status 2 quer dizer que estou no status atual, então vai ficar o circulo azul e com o circulo rodando
      backColor = Colors.blue;
      child = Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Text(title, style: TextStyle(color: Colors.white),),
          CircularProgressIndicator(//bolinha rodando com cor branca
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
        ],
      );
    } else{//se o pedido já passou por todos os status e está concluido ficará verde com um ícone de check
      backColor = Colors.green;
      child = Icon(Icons.check, color: Colors.white,);
    }

    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 20.0,
          backgroundColor: backColor,
          child: child,
        ),
        Text(subtitle),
      ],
    );
  }
}
