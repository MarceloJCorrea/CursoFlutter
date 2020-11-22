import 'package:flutter/material.dart';
import 'package:memesengracados/drawer/custom_drawer.dart';
import 'package:memesengracados/tabs/configuration_tab.dart';
import 'package:memesengracados/tabs/favorite_tab.dart';
import 'package:memesengracados/tabs/home_tab.dart';

class HomeScreen extends StatelessWidget {

  final _pageController = PageController();

  /*não está sendo usada*/
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget> [
        Scaffold(
          body: HomeTab(),
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          drawer: CustomDrawer(_pageController),
          appBar: AppBar(centerTitle: true, title: Text('Favoritos'),),
          body: FavoriteTab(),
        ),
        Scaffold(
          drawer: CustomDrawer(_pageController),
          appBar: AppBar(centerTitle: true, title: Text('Configuração'),),
          body: ConfigurationTab(),
        ),
      ],
    );
  }
}
