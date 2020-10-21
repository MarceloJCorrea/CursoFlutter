import 'package:flutter/material.dart';

class ImageDialog extends StatelessWidget {

  ImageDialog({@required this.image, @required this.onDelete});

  final dynamic image;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Dialog(//diálog para excluir a imagem
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.file(image),
          FlatButton(//botão para excluir imagem em vermelho
            child: Text('Excluir'),
            textColor: Colors.red,
            onPressed: (){
              Navigator.of(context).pop();
              onDelete();//função que exclui a imagem
            },
          )
        ],
      ),
    );
  }
}
