import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {

  ChatMessage(this.data, this.mine);

  final Map<String, dynamic> data;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10), //para que uma mensaem não fica colada na outra e na borda
      child: Row(//row pq nós queremos colocar a mensagem do lado do balãozinho, tanto na esquerda quanto na direita
        children: <Widget>[
          !mine ? // se não for meu usuário mostra a esquerda
          Padding(//para que o texto e a imagem não fiquem grudados no balãozinho do usuário
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(data['sendPhoto']),
            ),
          ): Container(),
          Expanded(//pq quero que o resto da mensagem ocupe o máximo possível da tela.
            child: Column(//column para colocar a mensagem e embaixo quem enviou
              crossAxisAlignment: mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,//se for meu usuário coloca o alinhamento no final, se não for meu usuário, alinhamento no início.
              children: <Widget>[
                data['imgUrl'] != null ?//verifica se é imagem, se for exibe, senão exibe texto.
                    Image.network(data['imgUrl'], width: 250,)
                :
                    Text(
                      data['text'],
                      textAlign: mine ? TextAlign.end : TextAlign.start,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                Text(
                    data['sendName'],//informação de quem enviou
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                ),
              ],
            ),
          ),
        mine ? // se for meu usuário mostra a direita
        Padding(//para que o texto e a imagem não fiquem grudados no balãozinho do usuário
        padding: const EdgeInsets.only(left: 16.0),
        child: CircleAvatar(
        backgroundImage: NetworkImage(data['sendPhoto']),
        ),
       ): Container(),
      ],
      ),
    );
  }
}
