import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'add_size_dialog.dart';

class ProductSizes extends FormField<List>{//vai armazenar uma lista de tamanhos no FormField, lista de Strings

  ProductSizes(
  {
    BuildContext context,//precisa passar um contexto para ter acesso ao contexto, passar na productscreen tb
    List initialValue,//abrir a tela vai mostrar a lista de tamanhos
    FormFieldSetter<List> onSaved,
    FormFieldValidator<List> validator,
  }) : super (//no super vai ter o estado atual do formfiled e aparir desse estado vai montar o widget dele.
    initialValue : initialValue,
    onSaved : onSaved,
    validator : validator,
    builder: (state){//pega o estado e exibe na tela dependendo do estado
      return SizedBox(//para definir uma altura do widget na tela
        height: 34,
        child: GridView(//tem um parâmetro que define a largura para separar os tamanhos
          padding: EdgeInsets.symmetric(vertical: 4),//distanciar o tamanhos dos outros widgets
          scrollDirection: Axis.horizontal,//poder desligar para a esquerda e direita
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(//vai deslisar da esquedar para a direita então o eixo principal é o eixo horizontal e o eixo cruzado é o eixo vertical
            crossAxisCount: 1, //itens do eixo vertical
            mainAxisSpacing: 8, //espaçamento no eixo vertical
            childAspectRatio: 0.5 //altura divide pela largura, largur é dobro da altura
          ),
          children: state.value.map(
                  (s){
                return GestureDetector(
                  onLongPress: (){//deletar um item
                    state.didChange(state.value..remove(s));//vai remover o tamanho da lista e vai refazer o widget inteiro
                  },
                  child: Container(
                    decoration: BoxDecoration(//para colocar a borda
                        borderRadius: BorderRadius.all(Radius.circular(4)),//curva da borda
                        border: Border.all(color: state.hasError ? Colors.red : Colors.pinkAccent, width: 3)//se tiver erro no conteúodo do campo tamanho vai mostrar uma borda vermelha indicando erro ao usuário.
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      s,//mostra o nome do tamanho
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                  ),
                );
              }
          ).toList()..add(//colorar o botão + para adicionar um tamanho
              GestureDetector(
                onTap: () async{
                  String size = await showDialog(context: context, builder: (context) => AddSizeDialog());//cria uma caixa de diálogo para adicionar um novo tamanho e armazena o que digitar no textField na variável siz
                  if(size != null) state.didChange(state.value..add(size));//pega a lista de tamanho, adicionou na lista de tamanho e fala pro estado que ele mudou no didchagne

                },
                child: Container(
                  decoration: BoxDecoration(//para colocar a borda
                      borderRadius: BorderRadius.all(Radius.circular(4)),//curva da borda
                      border: Border.all(color: Colors.pinkAccent, width: 3)
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '+',
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                ),
              )
          ),
        )
      );
    }
  );
}