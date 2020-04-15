import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {

  final IconData icon;//variavel do construtor de icone
  final String text;//variavel do construtor de texto

  DrawerTile(this.icon, this.text);//declaração do construtor

  @override
  Widget build(BuildContext context) {
    return Material(//etorna o material para dar um efeito visual ao clicar nos botões
      color: Colors.transparent,
      child: InkWell(
        onTap: (){},
        child: Container(
          height: 60.0,
          child: Row(//linha pois irá aparecer o ícone e o texto ao lado
            children: <Widget>[
              Icon(
                icon,
                size: 32.0,
                color: Colors.black,
              ),
              SizedBox(width: 32.0,), //esse widget deixará um espaço entre o ícone e o texto
              Text(
                text,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
