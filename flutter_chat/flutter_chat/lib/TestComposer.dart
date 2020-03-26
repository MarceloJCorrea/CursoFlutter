import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TextComposer extends StatefulWidget {

  TextComposer(this.sendMessage);//instancia a função

  final Function({String text, File imgFile}) sendMessage; //cria a função

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
            onPressed: () async {
              final File imgFile = await ImagePicker.pickImage(source: ImageSource.camera);//carrega a foto da camera e guarda da variável, await para esperar a foto
              if (imgFile == null) return; //sai da função caso usuário não tire a foto
              widget.sendMessage(imgFile: imgFile);
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
              widget.sendMessage(text: text);//envia a mensagem digitada
              _reset();
            },
          ),
        ),
        IconButton(
          icon: Icon(Icons.send),
          onPressed: _isComposing ? (){
            widget.sendMessage(text : _controller.text);//Enviar mensagem pelo botão
            _reset();
          } : null,//verifica se está digitando para habilitar o botão de enviar
        )
        ],
      ),

    );
  }
}
