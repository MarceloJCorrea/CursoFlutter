import 'package:flutter/material.dart';

class AddSizeDialog extends StatelessWidget {

  final _controller = TextEditingController();//cria o controlador do campo para armazenar o conteúdo digitado do tamanho

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.only(left: 8, right: 8, top: 8),//não alinha abaixo
        child: Column(
          mainAxisSize: MainAxisSize.min,//usar o mínimo de espaço possível, eixo principal é o main
          children: <Widget>[
            TextField(//usuário vai digiar um tamanho
              controller: _controller,
            ),
            Container(
              alignment: Alignment.centerRight,//alinhado no centro e a direita
              child: FlatButton(//botão para adicionar o tamanho
                child: Text('Add'),
                textColor: Colors.pinkAccent,
                onPressed: (){
                  Navigator.of(context).pop(_controller.text);//volta para tela anterior e passa o que foi digitado para a outra tela através do controlador do campo
                },
              ),
            )
          ],
        )
      )
    );
  }
}
