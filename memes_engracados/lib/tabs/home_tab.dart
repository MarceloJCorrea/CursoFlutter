import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memesengracados/tabs/configuration_tab.dart';
import 'package:memesengracados/tabs/favorite_tab.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:memesengracados/drawer/custom_drawer.dart';
import 'package:memesengracados/models/images_model.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {

  bool favorite  = false;
  final _pageController = PageController();
  ImagesModel imagesModel;

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
              getImages()
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

  FutureBuilder getImages() {
    return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('images').orderBy('imageId').get(),
        builder: (context, snapshot){
          if(!snapshot.hasData) {
            return Container(
              height: 500.0,
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            );
          }
          else if (snapshot.hasError){
            return Container(
              alignment: Alignment.center,
              height: 500,
              padding: EdgeInsets.all(10),
              child: Text('Não encontrado nenhuma meme, tente novamente!',
                style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),),
            );
          }
          else {
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
                                onPressed: () {},
                                icon: Icon(Icons.share),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.file_download),
                              ),
                              IconButton(
                                onPressed: setFavorite,
                                icon: favorite == false ? Icon(
                                    Icons.favorite_border) : Icon(
                                    Icons.favorite),
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  }).toList(),
            );
          }
        }
    );
  }

  void setFavorite (){
    setState((){
      if(favorite == false){
        favorite = true;
        print (favorite);}
      else{
        favorite = false;
        print (favorite);}
    });
  }
}
