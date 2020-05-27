import 'package:flutter/material.dart';
import 'package:lojavirtual/models/cart_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartPrice extends StatelessWidget {

  final VoidCallback buy;

  CartPrice(this.buy);//construtor para chamar a função de finalizar o pedido pela CartScreen

  @override
  Widget build(BuildContext context) {

    CartModel.of(context).updatePrices();//chama a função que atualiza os valores dos preços no carrinho

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: ScopedModelDescendant<CartModel>(
          builder: (context, child, model){

            double price = model.getProductsPrice();//retorna da função do cartModel
            double discount = model.getDiscount();//retorna da função do cartModel
            double ship = model.getShipPrice();//retorna da função do cartModel

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,//tudo ocupe o máximo de espaço possível, botão, textos tudo
              children: <Widget>[
                Text(
                  "Resumo do Pedido",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 12.0,),//espaçamento
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Subtotal"),
                    Text("R\$ ${price.toStringAsFixed(2)}")
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                  Text("Desconto"),
                  Text("R\$ ${discount > 0 ? '-' : ''}${discount.toStringAsFixed(2)}")
                ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                  Text("Entrega"),
                  Text("R\$ ${ship.toStringAsFixed(2)}")
                ],
                ),
                SizedBox(height: 12.0,),//espaçamento
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                  Text("Total", style: TextStyle(fontWeight: FontWeight.w500),),
                  Text("R\$ ${(price + ship - discount).toStringAsFixed(2)}", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16.0),)
                ],
                ),
                SizedBox(height: 12.0,),//espaçamento
                FlatButton(
                  child: Text("Finalizar Pedido"),
                  textColor: Colors.white,
                  color: Theme.of(context).primaryColor ,
                  onPressed: (){
                    model.finishOrder();//chama a função que fecha o pedido
                  },
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
