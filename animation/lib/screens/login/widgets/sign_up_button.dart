import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.only(//padding para deixar um espaço para colocar o botão em cima
        top: 200
      ),
      onPressed: (){},
      child: Text(
        'Não possui  uma conta? Cadastre-se!',
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,//caso não caiba na tela, vai aparecer 3 pontinhos
        style: TextStyle(
          fontWeight: FontWeight.w300,
          color: Colors.white,
          fontSize: 12,
          letterSpacing: 0.5//espaçamento do texto
        ),
      ),
    );

  }
}
