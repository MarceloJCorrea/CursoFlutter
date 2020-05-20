import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/data/cart_product.dart';
import 'package:lojavirtual/data/products_data.dart';
import 'package:lojavirtual/models/cart_model.dart';

class CartTile extends StatelessWidget {

  final CartProduct cartProduct; //construtor vai receber um cartProduct

  CartTile (this.cartProduct); //construtor

  //no cart_product não há todas as informações do produto, então temos que recuperar as informações do banco de dados, para que também possamos atualizar no carrinho, o preço do produto, por exemplo
  @override
  Widget build(BuildContext context) {

    Widget _buildContent(){
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,//alinhamento principal é start
        children: <Widget>[
          Container(
              padding: EdgeInsets.all(8.0),
              width: 120.0,
              child: Image.network(
                cartProduct.productData.images[0],
                fit: BoxFit.cover,
              ),
          ),
          Expanded(//expanded para cobrir toda a área que sobrar depois da imagem
            child: Container(//simplesmente para dar espaçamento
              padding: EdgeInsets.all(8.0),
              child: Column(//coluna pq tem um em cima do outro
                crossAxisAlignment: CrossAxisAlignment.start,//alinhar tudo á esquerda
                mainAxisAlignment: MainAxisAlignment.spaceBetween,//ficar espaçado na vertical
                children: <Widget>[
                  Text(
                      cartProduct.productData.title,//título do produto que está no productData
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17.0)
                  ),
                  Text(
                    "Tamanho: ${cartProduct.size}",//tamanho do produto que está no cartProduct
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),
                  Text(
                    "R\$ ${cartProduct.productData.price.toStringAsFixed(2)}",//preço do produto que está no productData
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor
                    )
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,//espaçamento igual entre todos os widgets na linha
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.remove, color: cartProduct.quantity > 1 ? Theme.of(context).primaryColor : Colors.grey[500],),
                        onPressed: cartProduct.quantity > 1 ? () {
                          CartModel.of(context).decProduct(cartProduct);//diminui a quantidade de itens no carrinho
                        } : null //se quantidade for maior do que 1 deixa remover, senão obriga usar o botaõ remover.
                      ),
                      Text(
                        cartProduct.quantity.toString(),
                      ),
                      IconButton(
                        icon: Icon(Icons.add, color: Theme.of(context).primaryColor,),
                        onPressed: (){
                          CartModel.of(context).incProduct(cartProduct);//adiciona mais itens do mesmo produto no carrinho
                        },
                      ),
                      FlatButton(
                        child: Text("Remover"),
                        textColor: Colors.grey[500],
                        onPressed: (){
                          CartModel.of(context).removeCartItem(cartProduct);//remove produto do carrinho
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      );
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
