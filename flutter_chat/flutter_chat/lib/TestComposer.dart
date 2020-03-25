import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextComposer extends StatefulWidget {

  TextComposer(this.sendMessage);//instancia a função

  Function(String) sendMessage; //cria a função

  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {

  bool _isComposing = false;

  final TextEditingController _controller = TextEditingController();

  void _reset(){//função que apaga o texto depois de enviar
    _controller.clear();
    setState(() {
    _isComposing = false;});
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),//coloca uma margem na horizontal.
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_camera),
            onPressed: (){

            },
          ),
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: InputDecoration.collapsed(hintText: "Enviar uma mensagem"),
            onChanged: (text){
              setState(() {
                _isComposing = text.isNotEmpty; //verifica se está digitando.
              });
            },
            onSubmitted: (text){
              widget.sendMessage(text);//envia a mensagem digitada
              _reset();
            },
          ),
        ),
        IconButton(
          icon: Icon(Icons.send),
          onPressed: _isComposing ? (){
            widget.sendMessage(_controller.text);//Enviar mensagem pelo botão
            _reset();
          } : null,//verifica se está digitando para habilitar o botão de enviar
        )
        ],
      ),

    );
  }
}
