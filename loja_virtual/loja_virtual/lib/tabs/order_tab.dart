import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/models/user_model.dart';
import 'package:lojavirtual/screens/login_screen.dart';
import 'package:lojavirtual/tiles/order_tile.dart';

class OrderTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    if(UserModel.of(context).isLoggedIn()){//se usuário está logado mostra os pedidos dele

      String uid = UserModel.of(context).firebaseUser.uid; //pega o usuário para ver os pedidos dele

      return FutureBuilder<QuerySnapshot>(
        future: Firestore.instance.collection('users').document(uid).collection('orders').getDocuments(),//busca no firestore os pedidos do usuário
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator(),);
          } else{
            return ListView(
              children: snapshot.data.documents.map((doc) => OrderTile(doc.documentID)).toList(),//pega os documentos transforma num mapa e transforma num ordertile para mostar todos os pedidos do usuário em forma de lista
            );
          }
        },
      );
    } else{//senão mostra uma tela solicitando o login para acompanhar os pedidos
      return  Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,//para usar o espaço da tela
            mainAxisAlignment: MainAxisAlignment.center,//para centralizar tudo
            children: <Widget>[
              Icon(Icons.view_list, color: Theme.of(context).primaryColor, size: 80.0,),//icone de lista
              SizedBox(height: 16.0,),//espaçamento
              Text("Faça o login para acompanhar", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),textAlign: TextAlign.center,), //texto para entrar com fonte e alinhado ao centro
              SizedBox(height: 16.0,),
              RaisedButton(
                child: Text("Entrar", style: TextStyle(fontSize: 18.0),),
                textColor: Colors.white, //texto do botão
                color: Theme.of(context).primaryColor,//cor do botão
                onPressed: (){
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context)=>LoginScreen())
                  );
                },
              )
            ],
          )
      );
    }
  }
}
