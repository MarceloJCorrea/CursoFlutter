import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class UserTile extends StatelessWidget {

  

  final Map<String, dynamic> user;//declara o mapa do user

  UserTile(this.user);//construtor do userTile

  @override
  Widget build(BuildContext context) {

    final textStyle = TextStyle(color: Colors.white); //pega a cor branca e add na variavel
    
    if(user.containsKey('money')){//se já carregou os dados irá mostrar
      return ListTile(
        title: Text(user['name'], style: textStyle,),//retorna o nome da lista
        subtitle: Text(user['email'], style: textStyle,),//retorna o email da lista
        trailing: Column(//é o que aparece no canto direito da tela
          crossAxisAlignment: CrossAxisAlignment.end,//alinhamento na direita
          children: <Widget>[
            Text('Pedidos: ${user['orders']}', style: textStyle,),//retorna a quantidade de pedidos da lista
            Text('Gasto: R\$${user['money'].toStringAsFixed(2)}', style: textStyle,)//retorna o valor dos pedidos da lista
          ],
        ),
      );
    } else
      return Container(//enquando não carregou os dados vai retornar nada, mas com uma animação do Shimmer
        margin: EdgeInsets.symmetric(horizontal: 16 , vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,//tudo alinhado a esquerda
          children: <Widget>[
            SizedBox(
              height: 20,//altura
              width: 400,//largura
              child: Shimmer.fromColors(
                child: Container(//efeito retângulo com ele correndo com os dados
                  color: Colors.white.withAlpha(50),
                  margin: EdgeInsets.symmetric(vertical: 4),//margem vertical
                ),
                baseColor: Colors.white,
                highlightColor: Colors.grey,
              ),
            ),
            SizedBox(
              height: 20,//altura
              width: 100,//largura
              child: Shimmer.fromColors(
                child: Container(//efeito retângulo com ele correndo com os dados
                  color: Colors.white.withAlpha(50),
                  margin: EdgeInsets.symmetric(vertical: 4),//margem vertical
                ),
                baseColor: Colors.white,
                highlightColor: Colors.grey,
              ),
            )
          ],
        ),
      );


  }
}
