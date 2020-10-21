import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:xlomobx/screens/create/components/image_source_modal.dart';
import 'package:xlomobx/stores/create_store.dart';

import 'image_dialog.dart';

class ImagesField extends StatelessWidget {

  ImagesField(this.createStore);//contstrutor

  CreateStore createStore;//obter o create store por parâmetro

  @override
  Widget build(BuildContext context) {

    void onImageSelected(File image){//só vai chamar a onImageSelected se em image_source_modal o cropeed estiver diferente de nulo
      createStore.images.add(image);
      Navigator.of(context).pop();
    }

    return Container(
      color: Colors.grey[200],
      height: 120,
      child: Observer(builder: (_){
        return ListView.builder(//lista de imagens
            //vai possibilitar colocar 5 imagens somente, se chegar na imagem 5 como o 5 é igual ao length não vai aparecer o botão para adicionar uma nova imagem
            itemCount: createStore.images.length > 5 ? createStore.images.length + 1 : 5, //mostra um balaozinho sem imagem, um balão extra pra adicinar uma nova imagem
            scrollDirection: Axis.horizontal,//imagens vai aparecer na horizontal
            itemBuilder: (_, index){//não vai ter bulider então fica com o _
              if(index == createStore.images.length)//significa que é o último balaozinho pra add imagem
              return Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),//espaçamento entre as bolinhas
                child: GestureDetector(//para que seja capaz de clicar na boinha
                  onTap: (){
                    if(Platform.isAndroid){//se for android aparece a caixa no padrão android
                      showModalBottomSheet(
                        context: context,
                        builder: (_) => ImageSourceModal(onImageSelected),
                      );
                    } else {//se for ios aparece a caixa de dialgo no padrão ios
                      showCupertinoModalPopup(
                        context: context,
                        builder: (_) => ImageSourceModal(onImageSelected),
                      );
                    }
                  },
                  child: CircleAvatar(//cria a bolinha na tela
                    radius: 44, //diâmetro de 88, tem 120 de altura no container 120 - 88 sobra 32 divide por 2 dá o padding de 16 em cima e em baixo
                    backgroundColor: Colors.grey[300],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,//centraliza as informações dentro do column
                      children: <Widget>[
                        Icon(//cria o ícone de camera para adicionar uma nova imagem
                          Icons.camera_enhance,
                          size: 50,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
              );
              else //mostra as imagens que foram selecionadas
                return Padding(
                  padding: EdgeInsets.fromLTRB(
                      8,
                      16,
                      index == 4 ? 8 : 0, //vai ter um espaçamento na direita somente se for o último item, senão vai ser 0
                      16),//espaçamento entre as bolinhas
                  child: GestureDetector(//para que seja capaz de clicar na boinha
                    onTap: (){
                      showDialog(
                          context: context,
                          builder: (_) => ImageDialog(
                            image: createStore.images[index],
                            onDelete: () => createStore.images.removeAt(index),//remove a imagem da lista de imagens
                          )
                      );
                    },
                    child: CircleAvatar(//cria a bolinha na tela
                      radius: 44,
                      backgroundImage: FileImage(createStore.images[index]),//balão com a imagem que vem de um arquivo
                    ),
                  ),
                );
            }
        );
      },)
    );
  }
}