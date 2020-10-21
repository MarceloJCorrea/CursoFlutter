import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gerenteloja/blocs/orders_bloc.dart';
import 'package:gerenteloja/blocs/user_bloc.dart';
import 'package:gerenteloja/tabs/orders_tabs.dart';
import 'package:gerenteloja/tabs/products_tab.dart';
import 'package:gerenteloja/tabs/users_tabs.dart';
import 'package:gerenteloja/widgets/edit_category_dialog.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  PageController _pageController;//modifica a página atual de forma automática
  int _page = 0; //vairavel que veriifca a pagina atual

  UserBloc _userBloc;
  OrdersBloc _ordersBloc;

  @override
  void initState() {//inicializa o page controller
    super.initState();
    _pageController = PageController();

    _userBloc = UserBloc(); //inicializa o userBloc
    _ordersBloc = OrdersBloc();
  }


  @override
  void dispose() {//libera a memória do page controller
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      bottomNavigationBar:
      Theme(//alterando o tema principal do tema
        data: Theme.of(context).copyWith(//copia tudo e modifica só o que quer
            canvasColor: Colors.pinkAccent,//modifica o fundo
            primaryColor: Colors.white, //modifica o ícone branco
            textTheme: Theme.of(context).textTheme.copyWith(
              caption: TextStyle(color: Colors.white54)//modifica o ícone não selecionado
            )
        ),
        child: BottomNavigationBar(//barra de baixo do app que vai trocar as tabs quando selecionado
          currentIndex: _page,//para mudar os itens selecionados conforme muda de página.
          onTap: (p){
            _pageController.animateToPage(//irá trocar de página ao clicar nos icones na barra de baixo
                p,
                duration: Duration(milliseconds: 500),
                curve: Curves.ease);
          },
          items: [//items que irá aparecer na barra de baixo
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Clientes')
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                title: Text('Pedidos')
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.list),
                title: Text('Produtos')
            ),
          ],
        ),
      ),
      body: SafeArea(//resolve a questão da barra do android invadir o conteúdo do app
        child: BlocProvider<UserBloc>(
          bloc: _userBloc,
          child: BlocProvider<OrdersBloc>(//fica dentro do UserBloc, pois ele precisará de acesso ao bloc dos clientes para mostrar informações na tela
            bloc: _ordersBloc,
            child: PageView(//vai mostrar as páginas clicando em clientes, produtos, e pedidos
              controller: _pageController,//irá controlar o pageview
              onPageChanged: (p){//atualiza o número da página e refaz a tela
                setState(() {
                  _page = p;
                });
              },
              children: <Widget>[
                UsersTab(),
                OrdersTab(),
                ProductsTab(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _buildFloating(),//botão varia de tela para tela, por isso coloca uma função
    );
  }

  Widget _buildFloating(){
    switch(_page){
      case 0://primeira página não tem ordenação
        return null;
      case 1: //na segunda página ordena por pedido concluído abaixo e acima
        return SpeedDial(
          child: Icon(Icons.sort),//icone para fazer a ordenação
          backgroundColor: Colors.pinkAccent,
          overlayColor: Colors.black,//quando clica no botão de ordenação vai colocar o que está atrás com uma cor suavemente preta
          overlayOpacity: 0.4,
          children: [
            SpeedDialChild(//ordena concluídos para baixo e coloca formatação
              child: Icon(Icons.arrow_downward, color: Colors.pinkAccent,),
              backgroundColor: Colors.white,
              label: "Concluídos Abaixo",
              labelStyle: TextStyle(fontSize: 14),
              onTap: (){
                _ordersBloc.setOrderCriteria(SortCriteria.READY_LAST);//ordena concluídos abaixo
              }
            ),
            SpeedDialChild(//ordena concluídos para cima e coloca formatação
                child: Icon(Icons.arrow_upward, color: Colors.pinkAccent,),
                backgroundColor: Colors.white,
                label: "Concluídos Acima",
                labelStyle: TextStyle(fontSize: 14),
                onTap: (){
                  _ordersBloc.setOrderCriteria(SortCriteria.READY_FIRST);//ordena concluídos acima
                }
            ),
          ],
        );
      case 2:
        return FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.pinkAccent,
          onPressed: (){
            showDialog(context: context, builder: (context) => EditCategoryDialog());
          }
        );
    }

  }

}

