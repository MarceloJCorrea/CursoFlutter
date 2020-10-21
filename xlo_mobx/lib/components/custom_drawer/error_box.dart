import 'package:flutter/material.dart';

class ErrorBox extends StatelessWidget {

  ErrorBox({this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    if(message == null)//caso não tenha erro, retorna um containe vazio
      return Container();
    return Container(//caso tenha erro, retorna uma caixa vermelha com os erros tratados que fica no parse_errors
      padding: EdgeInsets.all(8),
      color: Colors.red,
      child: Row(
        children: <Widget>[
          Icon(
            Icons.error_outline,
            color: Colors.white,
            size: 40,
          ),
          SizedBox(width: 16,),
          Expanded(
            child: Text(
              "Oops! $message. Por favor, tente novamente.",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          )
        ],
      ),
    );
  }
}
