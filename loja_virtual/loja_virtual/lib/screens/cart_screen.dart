import 'package:flutter/material.dart';
import 'package:lojavirtual/models/cart_model.dart';
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
    );
  }
}
