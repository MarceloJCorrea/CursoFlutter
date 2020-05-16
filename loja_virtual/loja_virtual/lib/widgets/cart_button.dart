import 'package:flutter/material.dart';
import 'package:lojavirtual/screens/cart_screen.dart';

class CartButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.shopping_cart, color: Colors.white,),
      onPressed: (){
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => CartScreen()),//ao clicar no botão do carrinho vai abrir a tela CartScreen
        );
      },
      backgroundColor: Theme.of(context).primaryColor,//cor primária no fundo
    );
  }
}
