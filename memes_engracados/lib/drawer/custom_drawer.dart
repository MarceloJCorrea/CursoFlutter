import 'package:flutter/material.dart';
import 'package:memesengracados/tiles/drawer_tile.dart';

class CustomDrawer extends StatelessWidget {

  final PageController pageController;

  CustomDrawer(this.pageController);

  @override
  Widget build(BuildContext context) {

    return Drawer(
    elevation: 0,
    child: Stack(
      children: [
        ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 120,
              width: 20,
              child: DrawerHeader(
                padding: EdgeInsets.all(20),
                child: Text('Memes engraçados',
                  style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  ),
                decoration: BoxDecoration(
                    color: Colors.orange
                ),
              ),
            ),
            DrawerTile(Icons.home, 'Início', pageController, 0),
            DrawerTile(Icons.star, 'Favoritos', pageController, 1),
            DrawerTile(Icons.build, 'Configuração', pageController, 2),
          ],
        ),
      ],
    ),
    );
  }
}
