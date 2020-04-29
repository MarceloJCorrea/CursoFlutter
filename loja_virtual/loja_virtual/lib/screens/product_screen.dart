import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/data/products_data.dart';

class ProductScreen extends StatefulWidget {

  final ProductData product;

  ProductScreen(this.product);//construtor que recebe o product data para utilizá-lo

  @override
  _ProductScreenState createState() => _ProductScreenState(product);
}

class _ProductScreenState extends State<ProductScreen> {

  final ProductData product;

  _ProductScreenState(this.product); //declara o construtor para pode usar o product de Product Data dentro da tela de produto sem precisar ficar chamando o widget toda hora

  @override
  Widget build(BuildContext context) {

    final Color primarycolor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 0.9,
            child: Carousel(
              images: product.images.map((url) {//peguei cada uma das urls da lista de imagens
                return NetworkImage(url);//transformei em uma imagem vinda do network
              }).toList(), //transforma em lista no final
              dotSize: 4.0, //tamanho do pontinho que simboliza qual image que tá selecionada
              dotSpacing: 15.0, //espaçamento entre os pontos
              dotBgColor: Colors.transparent, //cor de fundo do pontinho
              dotColor: primarycolor, //cor primaria do botão que está buscando da variável
              autoplay: false, //não deixa troca a imagem automaticamente, se não setar false, deve usar outras propridade e setar o tempo que irá trocar de imagem
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,//tenta ocupar a máxima largura possível dentro da coluna
              children: <Widget>[
                Text(
                  product.title,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500//peso da fonte
                  ),
                  maxLines: 3,//quantidade máxima de linhas do texto para não sobrepor outros campos se a descrição for muito grande
                ),
                Text(
                  "R\$ ${product.price.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,//dá uma destacada no preço
                    color: primarycolor
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
