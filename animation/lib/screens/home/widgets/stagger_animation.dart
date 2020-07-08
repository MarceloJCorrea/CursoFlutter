import 'package:animation/screens/home/widgets/animated_list_view.dart';
import 'package:animation/screens/home/widgets/fade_container.dart';
import 'package:animation/screens/home/widgets/home_top.dart';
import 'package:flutter/material.dart';

class StaggerAnimation extends StatelessWidget {

  AnimationController controller;

  StaggerAnimation({@required this.controller})
      :
        containerGrow = CurvedAnimation( //não passa o twen, pq o vai ser de 0 a 1 a animação
            parent: controller,
            curve: Curves.ease
        ),
        listSlidePosition = EdgeInsetsTween(
          begin: EdgeInsets.only(bottom: 0),
          //começo da animação com uma borda de zero
          end: EdgeInsets.only(bottom: 80), //fim da aniamação com 80 de borda
        ).animate(
            CurvedAnimation( //espera um pocuo e depois desde a lista
                parent: controller,
                curve: Interval(
                    0.325, //inicia a animação em 32.5% a animação
                    0.8, //e finaliza em 80%
                    curve: Curves.ease
                )
            )
        ),
        fadeAnimation = ColorTween(//animação começa num rosa mais escuro e termina na cor transparennte
          begin: Color.fromRGBO(247, 64, 106, 1.0),//opacidade 1.0
          end: Color.fromRGBO(247, 64, 106, 0.0)//opacidade 0.0
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.decelerate
          )
        );

  final Animation<double> containerGrow;
  final Animation<EdgeInsets> listSlidePosition; //animação do tipo EdgeInsets
  final Animation<Color> fadeAnimation;//animação do tipo Color

  Widget _buildAnimation(BuildContext context, Widget child) {
    return Stack(//consigo colocar um widget em cima do outro
      children: <Widget>[
        ListView(
          padding: EdgeInsets.zero, //para não ter nenhum espaçamento
          children: <Widget>[
            HomeTop(
              containerGrow: containerGrow,
            ),
            AnimatedListView(listSlidePosition: listSlidePosition)
          ],
        ),
        IgnorePointer(//ignora os toques dentro do widget, permite que eu interaja com a parte embaixo do container
          child: FadeContainer(
            fadeAnimation: fadeAnimation,//chama a animaçaõ fadeAnimation
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: AnimatedBuilder(
            animation: controller,
            builder: _buildAnimation
        ),
      ),
    );
  }
}
