import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataSearch extends SearchDelegate<String>{
  @override
  List<Widget> buildActions(BuildContext context) {

    return [
      IconButton(//apaga o conteúdo da pesquisa
        icon: Icon(Icons.clear),
        onPressed: (){
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {

    return IconButton(
      icon: AnimatedIcon(//icone de voltar com uma animação
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){
        close(context, null);//resultado null, pois não está realizando nehuma pesquisa
      },
    );
  }

  @override//função build desenha a tela, foi usado o delay para ajustar o erro do flutter
  Widget buildResults(BuildContext context) {//se quisesse mostrar os dados na própria tela de pesquisa
    //adia o close para após a tela terminar de montar (build)
    Future.delayed(Duration.zero).then((_) => close(context, query));//fecha a janela e passa o valor que escrevi e pesquisei, sem selecionar da lista do buildSuggestions

    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {//é o que vai ser chamado ao digitar algo na pesquisa
    if(query.isEmpty){
      return Container();//se não está pesquisando retorna nada - container vazio
    } else{
      return FutureBuilder<List>(
        future: suggestions(query),//chama a função suggestions passando a query (o que está sendo digitado) como parametro
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator(),);//se não contém dado na query retorna uma bolinha rodando
          } else {//se contém dado na pesquisa
            return ListView.builder(//vai ser chamado para cada um dos itens da lista
                itemBuilder: (context, index){
                  return ListTile(//widget que vai mostrar o conteúdo da perquisa com o texto (que é os dados retornados da pesquisa) e um icone
                    title: Text(snapshot.data[index]),
                    leading: Icon(Icons.play_arrow),
                    onTap: (){ //quando tocar num resultado
                      close(context, snapshot.data[index]);//fecha a tela e pega o resultado
                    },
                  );
                },
                itemCount: snapshot.data.length,//retorna o tamanho da lista
                );
          }
        },
      );
    }
  }

  Future<List> suggestions (String search) async{//função de sugestão do que está pesquisando
    http.Response response = await http.get(
      "http://suggestqueries.google.com/complete/search?hl=en&ds=yt&client=youtube&hjson=t&cp=1&q=$search&format=5&alt=json"
    );

    if(response.statusCode == 200){//se retornou dados do api
      return json.decode(response.body)[1].map((v){//para cada um dos v retorna a posição 0 do json
        return v[0];
      }).toList();
    } else{
      throw Exception('Falha ao carregar os dados');
    }
  }


}