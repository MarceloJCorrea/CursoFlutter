import 'package:flutter/material.dart';
import 'package:lojavirtual/models/cart_model.dart';
import 'package:lojavirtual/models/user_model.dart';
import 'package:lojavirtual/screens/login_screen.dart';
import 'package:lojavirtual/tiles/cart_tile.dart';
import 'package:scoped_model/scoped_model.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meu Carrinho",),
        actions: <Widget>[
          Container(
            alignment: Alignment.center,//vai coloar o texto quantidade de produtos alinhado no centro
            padding: EdgeInsets.only(right: 8.0),
            child: ScopedModelDescendant<CartModel>(
              builder: (context, child, model){
                int p = model.products.length; //quantidade de produtos que temos no carrinho
                return Text(
                  "${p ?? 0} ${p == 1 ? "ITEM" : "ITENS"}", //p??0 se p for nulo, retorna 0, caso contrário retorna o próprio valor de p. ${p == 1 ? "ITEM" : "ITENS"}" se p = 1 mostra item, senão mostra itens
                  style: TextStyle(fontSize: 17.0,),
                );
              },
            ),
          )
        ],
      ),
      body: ScopedModelDescendant<CartModel>(
        builder: (context, child, model){
          if(model.isLoading && UserModel.of(context).isLoggedIn()){//se estou carregando o carrinho e estou logado, mostra a bolinha de progresso
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (!UserModel.of(context).isLoggedIn()){//se não estou logado, mostra um ícone, mensagem e botão para entrar
            return Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,//para usar o espaço da tela
                mainAxisAlignment: MainAxisAlignment.center,//para centralizar tudo
                children: <Widget>[
                  Icon(Icons.remove_shopping_cart, color: Theme.of(context).primaryColor, size: 80.0,),//icone do carrinho
                  SizedBox(height: 16.0,),//espaçamento
                  Text("Faça o login para adicionar produtos", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),textAlign: TextAlign.center,), //texto para entrar com fonte e alinhado ao centro
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
          } else if(model.products == null || model.products.length == 0){//se não houver produtos no carrinho retorna uma mensagem
            return Center(
              child: Text("Não há produtos no carrinho", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
            );
          } else
          return ListView(
            children: <Widget>[
              Column(
                children: model.products.map((products) {//pegando cada um dos produtos da lista de produtos do cartmodel e transformando em um CartTile
                  return CartTile(products);
                }).toList()
              )
            ],
          );
        },
      ),
    );
  }
}
