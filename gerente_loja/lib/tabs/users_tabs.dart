import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:gerenteloja/blocs/user_bloc.dart';
import 'package:gerenteloja/tile/user_tile.dart';

class UsersTab extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final _userBloc = BlocProvider.of<UserBloc>(context);

    return Column(//coluna com o listview junto tem que por dentro de um Expanded
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),//dá um espaçamento no começo para não ficar colado na barra
          child: TextField(//cria o campo de pesquisa
            style: TextStyle(
              color: Colors.white
            ),
            decoration: InputDecoration(
              hintText: 'Pesquisar',//hint do campo de pesquisa
              hintStyle: TextStyle(color: Colors.white),//estilo do hint de pesquisa
              icon: Icon(Icons.search, color: Colors.white,),//icone do hint de pesquisa
              border: InputBorder.none//sem borda
            ),
            onChanged: _userBloc.onChangedSearch,//chama a função do campo de busca
          ),
        ),
        Expanded(//para resovler o erro do listview dentro da coluna
          child: StreamBuilder<List>(
            stream: _userBloc.outUsers,//chama a stream do users bloc
            builder: (context, snapshot) {
              if(!snapshot.hasData){//se não contém dado retorna o circulo girando na cor pink
                return Center(child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.pinkAccent),),
                );
              }
              else if(snapshot.data.length == 0){//se não tem usuário
                return Center(child: Text("Nenhum usuário encontrado",
                  style: TextStyle(color: Colors.pinkAccent),),
                );
              }
              else {return ListView.separated(//lista com um separador
                  itemBuilder: (context, index){
                    return UserTile(snapshot.data[index]);//retona o que está no user tile
                  },
                  separatorBuilder: (context, index){
                    return Divider();//separador
                  },
                  itemCount: snapshot.data.length//tamanho da lista que irá buscar do Firebase
              );
              }
            }
          ),
        )
      ],
    );
  }
}
