import 'package:flutter/material.dart';
import 'package:memesengracados/tiles/drawer_tile.dart';

class CustomDrawer extends StatelessWidget {

  final PageController pageController;

  CustomDrawer(this.pageController);

  @override
  Widget build(BuildContext context) {

    return Drawer(
    child: Stack(
      children: [
        ListView(
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
            DrawerTile(Icons.home, 'Início', pageController, 0),
            DrawerTile(Icons.star, 'Favoritos', pageController, 1),
            DrawerTile(Icons.build, 'Configuração', pageController, 2),

            /*ListTile(
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
                      builder: (_) => FavoriteTab())
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
                       builder: (_) => ConfigurationTab())
                   );
                 },
               ),*/
          ],
        ),
      ],
    ),
    );
  }
}
