import 'package:flutter/material.dart';

class FadeContainer extends StatelessWidget {

  final Animation<Color> fadeAnimation;

  FadeContainer({this.fadeAnimation});

  @override
  Widget build(BuildContext context) {
    return Hero(//Mesmo Hero do stragger animation para dar o efeito da troca de cor entre as telas
      tag: 'fade',
      child: Container(
        decoration: BoxDecoration(
          color: fadeAnimation.value
        ),
      ),
    );
  }
}
