import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:lojavirtual/data/cart_product.dart';
import 'package:lojavirtual/data/products_data.dart';
import 'package:lojavirtual/models/cart_model.dart';
import 'package:lojavirtual/models/user_model.dart';
import 'package:lojavirtual/screens/cart_screen.dart';
import 'package:lojavirtual/screens/login_screen.dart';

class ProductScreen extends StatefulWidget {

  final ProductData product;

  ProductScreen(this.product);//construtor que recebe o product data para utilizá-lo

  @override
  _ProductScreenState createState() => _ProductScreenState(product);
}

class _ProductScreenState extends State<ProductScreen> {

  final ProductData product;

  String size;

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
                ),
                SizedBox(//coloca um espaço entre a preço do produto e o label tamanho
                  height: 16.0,
                ),
                Text(
                  "Tamanho",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(//coloca um espacinho entre o texto tamanho e os tamanhos a escolher
                  height: 34.0,
                  child: GridView(//poderia ser o ListView que é a mesma coisa
                    scrollDirection: Axis.horizontal, //se não passar esse parâmetro ele vai ficar na vertical por padrão
                    padding: EdgeInsets.symmetric(vertical: 4.0),//espaçamento emcima e embaixo
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 8.0,//espaçamento do eixo princical, espaçamento na horizontal
                      childAspectRatio: 0.5,//divisão entre a altura pela largura, 0.5 largura duas vezes a altura é 0.5
                    ),
                    children: product.sizes.map(//lista de tamanhos e mapeando em uma lista
                        (s){//strign s
                          return GestureDetector(//gesture detector para que possamos detectar o cliente para escolher o tamanho
                            onTap: (){
                              setState(() {
                                size = s;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(4.0)),//colocar uma borda circular nos botões de tamanho
                                border: Border.all(
                                  color: s == size ? primarycolor : Colors.grey[500],//se essa for a cor selecionada vai ficar a cor primaria, caso contrário vai fizer um cinza.
                                  width: 3.0
                                )
                              ),
                              width: 50.0,
                              alignment: Alignment.center,
                              child: Text(s),//texto é o tamanho que retornou da lista que foi feito o mapeamento do que retornou do firebase
                            ),
                          );
                        }
                    ).toList()
                  ),
                ),
                SizedBox(
                  height: 16.0,//separador somente para não ficar colado no tamanho
                ),
                SizedBox(
                  height: 44.0,
                  child: RaisedButton(//botão para adicionar no carrinho
                    onPressed:
                        size != null ?//verifica se foi selecionado tamanho se sim, libera o botão senão, retorna null
                        (){ //UserModel.of(context) recebe um objeto do tipo UserModel, igual ao Navitator.of(context).
                          if(UserModel.of(context).isLoggedIn()){ //verifica se o usuário está logado, se estiver adiciona no carrinho

                            CartProduct cartProduct = CartProduct();
                            cartProduct.size = size;//tamanho que será adicionado no carrinho
                            cartProduct.quantity = 1;//quantidade que será adicionada ao carrinho, fixo 1.
                            cartProduct.pid = product.id;//pega o id do produto dessa tela e passa para o CartProduct.pic
                            cartProduct.category = product.category; //categoria é setada no categoryscreen
                            cartProduct.productData = product; //para guardar o resumo do pedido no carrinho e no pedido

                            CartModel.of(context).addCartItem(cartProduct);//adiciona no carrinho, usa o CartProduct, tem que declarar o construtor vazio na classe

                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => CartScreen()), //ao adicionar o item vai abrir a tela do carrinho
                            );
                          }
                          else {
                            Navigator.of(context).push(//senão estiver abre a tela de login do usuário
                              MaterialPageRoute(builder: (context) => LoginScreen()),
                            );
                          }
                        } : null,
                    child: Text(//texto do botão
                      UserModel.of(context).isLoggedIn() ? "Adicionar ao carrinho" : "Entre para Comprar",//verifica se o usuário está logado, se estiver mostra o texto do botão para adicionar ao carrinho, senão mostra para entrar para comprar
                      style: TextStyle(
                        fontSize: 18.0
                      ),
                    ),
                    color: primarycolor,//cor do botão
                    textColor: Colors.white,//cor do texto do botão
                  )
                ),
                SizedBox(//coloca um espaço entre a preço do produto e o label tamanho
                  height: 16.0,
                ),
                Text(
                  "Tamanho",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  product.description,
                  style: TextStyle(
                    fontSize: 16.0
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
