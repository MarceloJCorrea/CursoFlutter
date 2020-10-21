import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xlomobx/components/custom_drawer/custom_drawer.dart';
import 'package:xlomobx/stores/create_store.dart';

import 'components/images_field.dart';

class CreateScreen extends StatelessWidget {
  
  final CreateStore createStore = CreateStore();//declara a create store

  final labelStyle = TextStyle(
    fontWeight: FontWeight.w800,
    color: Colors.grey,
    fontSize: 18,
  );

  final contentPadding = const EdgeInsets.fromLTRB(16, 10, 12, 10);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text('Criar Anúncio'),
        centerTitle: true,
      ),
      body: Card(
        clipBehavior: Clip.antiAlias,//força a borda ficar arredondada
        margin: const EdgeInsets.symmetric(horizontal: 16),//o card fica afastado na esquerda e direita
        shape: RoundedRectangleBorder(//coloca uma borda no card
            borderRadius: BorderRadius.circular(16)
        ),
        elevation: 8,//sombra nas bordas
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ImagesField(createStore),//não usa o provider porque ele não vai ficar repassando, se fosse, precisaria utilizar, então pode ser passado por parâmetro somente para o images field
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Título *',
                labelStyle: labelStyle,
                contentPadding: contentPadding,
              ),
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Descrição *',
                labelStyle: labelStyle,
                contentPadding: contentPadding,
              ),
              maxLines: null,//possibilita várias linhas no campo de descrição
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Preço *',
                labelStyle: labelStyle,//estilo que é uma variável
                contentPadding: contentPadding,//bordas que é uma variável
                prefixText: "R\$ ",//prefixo do campo de preço
              ),
              keyboardType: TextInputType.number,//aparece o teclado númerico somente
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly,//permitir dígitos no campo
                RealInputFormatter( centavos: true,)//campo aceita centavos
              ],
            ),
          ],
        ),
      ),
    );
  }
}
