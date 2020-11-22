import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memesengracados/tabs/configuration_tab.dart';
import 'package:memesengracados/tabs/favorite_tab.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:memesengracados/drawer/custom_drawer.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {

  bool favorite  = false;
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Scaffold(
          drawer: CustomDrawer(_pageController),
          appBar: AppBar(
            title: Text('Memes engraçados', style: TextStyle(color: Colors.black),),
            centerTitle: true,
          ),
          body: ListView(
            children: [
              FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance.collection('images').orderBy('id').get(),
                  builder: (context, snapshot){
                    return getImages();
                  }
              )
            ],
          ),
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

  FutureBuilder getImages(){
    return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('images').orderBy('id').get(),
        builder: (context, snapshot){
          if(!snapshot.hasData) {
            return Center(child: CircularProgressIndicator(),);
          }
          return Column(
            children: snapshot.data.docs.map(
                      (doc) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: doc.data()['imgUrl'],
                            fit: BoxFit.cover,
                          ),
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
                    );
                  }).toList(),
          );
        }
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
