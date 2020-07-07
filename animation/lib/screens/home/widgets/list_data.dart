import 'package:flutter/material.dart';

class ListData extends StatelessWidget {

  final String title; //titulo
  final String subtitle; //subtitulo
  final ImageProvider image; //imagem que vai aparecer no canto
  final EdgeInsets margin; //responsável por fazer a anidamação

  ListData({this.title, this.subtitle, this.image, this.margin});//construtor do listData

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin, //margem que pegará do parâmetro
      decoration: BoxDecoration(//decoração para colocar as bordas em cima e embaixo
        color: Colors.white,
        border: Border(
          top: BorderSide(//borda acima
            color: Colors.grey, width: 1.0
          ),
          bottom: BorderSide(//borda embaixo
                color: Colors.grey, width: 1.0
          )
        )
      ),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
            width: 60.0,//largura da imagem
            height: 60.0,//altura da imagem
            decoration: BoxDecoration(
              shape: BoxShape.circle, //imagem vai ter um formato circular
              image: DecorationImage(image: image)
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                subtitle,
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                    fontWeight: FontWeight.w300
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
