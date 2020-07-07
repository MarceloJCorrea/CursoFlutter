import 'package:animation/screens/home/widgets/animated_list_view.dart';
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
        );

  final Animation<double> containerGrow;
  final Animation<EdgeInsets> listSlidePosition; //animação do tipo EdgeInsets

  Widget _buildAnimation(BuildContext context, Widget child) {
    return ListView(
      padding: EdgeInsets.zero, //para não ter nenhum espaçamento
      children: <Widget>[
        HomeTop(
          containerGrow: containerGrow,
        ),
        AnimatedListView(listSlidePosition: listSlidePosition)
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
