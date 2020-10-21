import 'package:flutter/material.dart';
import 'file:///D:/Estudar/Flutter/apps/memes_engracados/lib/screens/home_screen.dart';
import 'package:memesengracados/screens/configuration_screen.dart';
import 'package:memesengracados/screens/favorite_screen.dart';

class CustomDrawer extends StatelessWidget {

  final PageController _pageController;

  CustomDrawer(this._pageController);

  @override
  Widget build(BuildContext context) {

    return Drawer(
    elevation: 0,
    child: ListView(
      controller: _pageController,
      padding: EdgeInsets.zero,
      children: <Widget>[
        Container(
          height: 120,
          width: 30,
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
        ListTile(
            leading: Icon(Icons.home),
            trailing: Icon(Icons.play_arrow),
            title: Text('Início', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),),
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => HomeScreen())
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.star),
            trailing: Icon(Icons.play_arrow),
            title: Text('Favoritos', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),),
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => FavoriteScreen())
              );
            },
          ),
          Divider(color: Colors.grey,),
          ListTile(
             leading: Icon(Icons.build),
             trailing: Icon(Icons.play_arrow),
             title: Text('Configuração', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),),
             onTap: (){
               Navigator.of(context).push(MaterialPageRoute(
                   builder: (_) => ConfigurationScreen())
               );
             },
           ),
      ],
    ),
    );
  }
}
