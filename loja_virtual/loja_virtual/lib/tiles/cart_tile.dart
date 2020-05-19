import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/data/cart_product.dart';
import 'package:lojavirtual/data/products_data.dart';

class CartTile extends StatelessWidget {

  final CartProduct cartProduct; //construtor vai receber um cartProduct

  CartTile (this.cartProduct); //construtor

  //no cart_product não há todas as informações do produto, então temos que recuperar as informações do banco de dados, para que também possamos atualizar no carrinho, o preço do produto, por exemplo
  @override
  Widget build(BuildContext context) {

    Widget _buildContent(){

    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0), //margin dá um espaçamento fora do widget, o padding dá dentro
      child: cartProduct.productData == null ?  //se no cart_product não tiver produto no cache, vai procurar no banco de dados
        FutureBuilder<DocumentSnapshot>(//senão tem os dados buscca no firabase, se tem os dados mostra no _buildContent()
          future: Firestore.instance.collection('products').document(cartProduct.category)
          .collection('itens').document(cartProduct.pid).get(),//busca os dados do carrino no firebase
          builder: (context, snapshot){
            if(snapshot.hasData){//se estou carregando
              cartProduct.productData = ProductData.fromDocument(snapshot.data);//converte o que retornou do firebase para o cartProduct
              return _buildContent();//já tem os dados e simplesmente mostra as informações do produto
            } else
              return Container(//caso esteja carregando as informações mostra a bolinha rodando
                height: 70.0,
                child: CircularProgressIndicator(), alignment: Alignment.center,
              );
          },
        ) :
          _buildContent()//já tem os dados e simplesmente mostra as informações do produto
    );
  }
}
