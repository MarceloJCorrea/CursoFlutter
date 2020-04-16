import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {

  final IconData icon;//variavel do construtor de icone
  final String text;//variavel do construtor de texto
  final PageController controller;
  final int page;

  DrawerTile(this.icon, this.text, this.controller, this.page);//declaração do construtor

  @override
  Widget build(BuildContext context) {
    return Material(//etorna o material para dar um efeito visual ao clicar nos botões
      color: Colors.transparent,
      child: InkWell(
        onTap: (){
          Navigator.of(context).pop();//fecha o drawer
          controller.jumpToPage(page);//pula para a página que o usuário irá chamar.
        },
        child: Container(
          height: 60.0,
          child: Row(//linha pois irá aparecer o ícone e o texto ao lado
            children: <Widget>[
              Icon(
                icon,
                size: 32.0,
                color: controller.page == page ?//se for a página que está selecionada no drawer aparece a cor do tema, senão um cinza com tonalidade 700
                    Theme.of(context).primaryColor : Colors.grey[700],
              ),
              SizedBox(width: 32.0,), //esse widget deixará um espaço entre o ícone e o texto
              Text(
                text,
                style: TextStyle(
                  fontSize: 16.0,
                  color: controller.page == page ? //se for a página que está selecionada no drawer aparece a cor do tema, senão um cinza com tonalidade 700
                  Theme.of(context).primaryColor : Colors.grey[700],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
