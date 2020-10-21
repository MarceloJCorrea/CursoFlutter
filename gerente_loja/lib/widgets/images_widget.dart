import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'images_source_sheet.dart';

class ImagesWidget extends FormField<List>{ //vai ter uma lista de imagens com validações, por isso temque por o List

  ImagesWidget({
    BuildContext context,
    FormFieldSetter<List> onSaved,//função que vai chamar para salvar os dados do formulário
    FormFieldValidator<List> validator,//função para validar o campo
    List initialValue, //valor inicial do campo
    bool autoValidate = false//para que não valide ao digitar somente ao salvar

  }) : super(
    onSaved: onSaved,
    validator: validator,
    initialValue: initialValue,
    autovalidate: autoValidate,
    builder: (state){//estado do formulário, valor atual do formulário, erro, caso tenha erro.
      return Column(//vai colocar as imagens e o código de erro, vai aparecer em baixo, imagens em cima e erro abaixo.
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(//container para especificar a altura das imagens
            height: 124,
            padding: EdgeInsets.only(top: 16, bottom: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,//rolar a lista de imagens na vertical
              children: state.value.map<Widget>((i){//vai ter o mapa das imagens, tanto imagens do firebase quando imagens a salvar
                //desenhar cada uma das imagens
                return Container(
                  height: 100,
                  width: 100,
                  margin: EdgeInsets.only(right: 8),//espaço entre uma imagem e outra na vertical
                  child: GestureDetector(//coloca o gesturedetector para que seja possível tocar na imagem
                    //vai ter tanto strings que são imagens urls de imagens já salvas quanto files que são imagens que vou pegar da galeria ou da camera
                    child: i is String ? Image.network(i, fit: BoxFit.cover,) ://verifica se é uma String com a url de imagens ou imagens em arquivos
                        Image.file(i, fit: BoxFit.cover,),
                    onLongPress: () { 
                      state.didChange(state.value..remove(i));//se segurar a imagem apertada vai remover a imagem, o .. retorna o valor final e não o resultado da operação
                    }
                  ),
                );
              }).toList()..add(
                GestureDetector(//gesture detector não é lista de contairer se não colocar como Widget o map
                  child: Container(
                    height: 100,
                    width: 100,
                    child: Icon(Icons.camera_enhance, color: Colors.white,),
                    color: Colors.white.withAlpha(50),//para ficar um pouco transparente
                  ),
                  onTap: (){
                    showModalBottomSheet(context: context, builder:
                    (context) => ImageSourceSheet(
                      onImageSelected: (image){
                        state.didChange(state.value..add(image));//adicionou a imagem na lista e falei que o conteúdo da lista mudou
                      },
                     )
                    );
                  },
                )
              )
            ),
          ),
          state.hasError ? Text(//se tiver erro vai mostrar uma msg de erro, senão vai mostrar um container vazio sem nada.
            state.errorText,
            style: TextStyle(
              color: Colors.red,
              fontSize: 12
            ),
          ): Container()
        ],
      );
  }
  );
}