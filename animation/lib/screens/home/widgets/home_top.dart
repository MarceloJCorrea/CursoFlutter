import 'package:animation/screens/home/widgets/category_screen.dart';
import 'package:flutter/material.dart';

class HomeTop extends StatelessWidget {

  final Animation<double> containerGrow;

  HomeTop({@required this.containerGrow});

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size; //pega o tamanho da tela

    return Container(
      height: screenSize.height * 0.4, //retangulo vai ocupar 40% da tela
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/background.jpg'),
          fit: BoxFit.cover, //imagem vai completar o retangulo inteiro
        )
      ),
      child: SafeArea(//não invade a barra de status
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, //espaçamento do eixo
          children: <Widget>[
            Text(
              'Bem-Vindo Marcelo',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w300,
                color: Colors.white
              ),
            ),
            Container(//vai ter a imagem de perfil e a bolinha com quantas tarefas tenho pendentes
              alignment: Alignment.topRight, //alinhamento do filho do container
              width: containerGrow.value * 120, //multiplica por 120 pq quero que a imagem tenha 120 no final quanto chegar a 1
              height: containerGrow.value * 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('images/ticket.jpg'),
                  fit: BoxFit.cover
                )
              ),
              child: Container(
                width: containerGrow.value * 35,
                height: containerGrow.value * 35,
                margin: EdgeInsets.only(left: 80),
                child: Center(
                  child: Text(
                    '2',
                    style: TextStyle(
                      fontSize: containerGrow.value * 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.white
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(80, 210, 194, 1.0)
                ),
              ),
            ),
            CategoryScreen()
          ],
        ),
      ),
    );
  }
}
