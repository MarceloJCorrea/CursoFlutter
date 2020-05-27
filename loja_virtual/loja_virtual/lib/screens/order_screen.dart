import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {

  final String orderId;

  OrderScreen(this.orderId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pedido Realizado"), //app bar da tela do pedido que foi realizado
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Icon(Icons.check,
             color: Theme.of(context).primaryColor,
             size: 80.0,
            ),
            Text("Pedido Realizado com sucesso",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
            ),
            ),
            Text("Código do Pedido: $orderId", style: TextStyle(fontSize: 16.0),),//mostra o códido do pedido realizado após fechar a compra no carrinho
          ]
        ),
      ),
    );
  }
}
