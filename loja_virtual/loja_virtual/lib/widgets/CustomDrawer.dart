import 'package:flutter/material.dart';
import 'package:lojavirtual/screens/login_screen.dart';
import 'package:lojavirtual/tiles/drawer_tile.dart';

class CustomDrawer extends StatelessWidget {

  final PageController pageController; //declara a variavel do page controle para ter acesso a ele

  CustomDrawer(this.pageController); //intancia o construtor para ter acesso ao pagecontrole

  @override
  Widget build(BuildContext context) {

    Widget _buldDrawerBack() => Container(//cria um degradê de cores, inicia no centro um azul claro e termina no centro como branco
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 203, 236, 241),//azul clarinho
                Colors.white//branco
              ],
              begin: Alignment.topCenter,//começa no centro superior
              end: Alignment.bottomCenter//termina no centro inferior
          )
      ),
    );

    return Drawer(
      child: Stack(
        children: <Widget>[
          _buldDrawerBack(),
          ListView(
            padding: EdgeInsets.only(left: 32.0, top: 16.0), //margem a esqueda para não ficar grudado no canto e no topo para não ficar grudado no top
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 8.0),//margem embaixo do separador
                padding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 8.0),
                height: 170.0,
                child: Stack(//stack para posicionar os componente na tela, texto, texto, texto, colum não dá para fazer isso, stack dá para posicionar dentro do retângulo
                  children: <Widget>[
                    Positioned(
                      top: 8.0,
                      left: 0.0,
                      child: Text(
                        "Flutter's \nClothing",
                        style: TextStyle(fontSize: 34.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      child: Column(//coluna que vai ter o dois texto dentro, posicionados abaixo e a esquerda (bottom e left)
                        crossAxisAlignment: CrossAxisAlignment.start,//alinhamento no início
                        children: <Widget>[
                          Text(
                            'Olá',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          GestureDetector(//gesture detector para por usar o botão de cadastrar com o on tap
                            child:
                              Text(
                                'Entre ou cadastre-se >',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,//chama a cor primária do tema, declarada na home page
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            onTap: (){
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context)=>LoginScreen())
                              );
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Divider(),//divide o OLá, entre ou cadastre-se do restante
              DrawerTile(Icons.home, "Início", pageController, 0),//chama o Drawertile com o icone e nome
              DrawerTile(Icons.list, "Produtos", pageController, 1),//chama o Drawertile com o icone e nome
              DrawerTile(Icons.location_searching, "Lojas", pageController, 2),//chama o Drawertile com o icone e nome
              DrawerTile(Icons.playlist_add_check, "Meu Pedidos", pageController, 3),//chama o Drawertile com o icone e nome
            ],
          )
        ],
      ),
    );
  }
}
