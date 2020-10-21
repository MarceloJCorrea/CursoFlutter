import 'package:flutter/material.dart';
import 'package:memesengracados/drawer/custom_drawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  final _pageController = PageController();

  bool favorite  = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(_pageController),
      appBar: AppBar(
        title: Text('Memes engraçados', style: TextStyle(color: Colors.black),),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Image.asset('image1.jpg', fit: BoxFit.cover,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        onPressed: (){},
                        icon: Icon(Icons.share),
                      ),
                      IconButton(
                        onPressed: (){},
                        icon: Icon(Icons.file_download),
                      ),
                      IconButton(
                        onPressed: setFavorite,
                        icon: favorite == false ? Icon(Icons.favorite_border) : Icon(Icons.favorite),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void setFavorite (){
    setState((){
      if(favorite == false)
        favorite = true;
      else
        favorite = false;
    });

  }
}
