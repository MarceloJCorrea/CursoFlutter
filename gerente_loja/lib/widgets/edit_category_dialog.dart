import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerenteloja/blocs/category_bloc.dart';
import 'package:gerenteloja/widgets/images_source_sheet.dart';

class EditCategoryDialog extends StatefulWidget {

  final DocumentSnapshot category;

  EditCategoryDialog({this.category});

  @override
  _EditCategoryDialogState createState() => _EditCategoryDialogState(
    category: category
  );
}

class _EditCategoryDialogState extends State<EditCategoryDialog> {
  final CategoryBloc _categoryBloc;

  final TextEditingController _controller;

  _EditCategoryDialogState({DocumentSnapshot category}) : //quando estiver editando a categoria vamos passar esse valor para o DocumentSnapshot quando formos criar uma categoria esse mesmo valor será nulo
        _categoryBloc = CategoryBloc(category),
        _controller = TextEditingController(text:  category != null ? //se já existe a categoria vai colocar o texto dela, senão coloca um texto vazio
        category.data['title'] : ''
        );

  @override
  Widget build(BuildContext context) {
    return Dialog(//abre uma caixa de diálogo ao clicar na imagem da categoria
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,//usar o mínimo de espaço da tela
          children: <Widget>[
            ListTile(
              leading: GestureDetector(
                onTap: (){
                  showModalBottomSheet(
                      context: context,
                      builder: (context) => ImageSourceSheet(
                        onImageSelected: (image){
                          Navigator.of(context).pop(//remove o diálogo e logo em seguida seta a imagem do arquivo do bloc
                            _categoryBloc.setImage(image)
                          );
                        },
                      ));
                },
                child: StreamBuilder(
                    stream: _categoryBloc.outImage,
                    builder: (context, snapshot) {
                      if(snapshot.data != null)
                        return CircleAvatar(
                          child: snapshot.data is File ?
                          Image.file(snapshot.data, fit: BoxFit.cover,) : //caso seja um arquivo, mostra o arquivo
                          Image.network(snapshot.data, fit: BoxFit.cover,),//caso seja uma url de imagem
                          backgroundColor: Colors.transparent,
                        );
                      else return Icon(Icons.image);
                    }
                ),
              ),
              title: StreamBuilder<String>(//dentro do streambuilder para ir validando o conteúdo
                stream: _categoryBloc.outTitle,
                builder: (context, snapshot) {
                  return TextField(
                    controller: _controller,
                    onChanged: _categoryBloc.setTitle,//bloc que faz a validação no setTitle
                    decoration: InputDecoration(
                      errorText: snapshot.hasData ? snapshot.error : null //se tiver erro, mostra o erro, senão não mostra nada
                    ),
                  );
                }
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,//centralizar os botões na tela espandidos
              children: <Widget>[
                StreamBuilder<bool>(
                    stream: _categoryBloc.outDelete,
                    builder: (context, snapshot) {
                      if(snapshot.hasData) return Container();
                      return FlatButton(//botão excluir do diálogo
                        child: Text('Excluir'),
                        textColor: Colors.red,
                        onPressed: snapshot.data ? (){//se tiver dado libera o botão, senão fica bloqueado
                          _categoryBloc.delete();
                          Navigator.of(context).pop();
                        } : null,
                      );
                    }
                ),
                StreamBuilder<bool>(
                  stream: _categoryBloc.submitValid,
                  builder: (context, snapshot) {
                    return FlatButton(//botão salvar do diálogo
                      child: Text('Salvar'),
                      onPressed: snapshot.hasData ? () async {
                        await _categoryBloc.saveData();//chama a função de salvar
                        Navigator.of(context).pop();
                      } : null, //habilita ou desabilita o botão salvar, caso a combinação de imagem e título esteja preenchido
                    );
                  }
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

