import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:xlomobx/screens/login/login_screen.dart';
import 'package:xlomobx/stores/page_store.dart';
import 'package:xlomobx/stores/user_manager_store.dart';

class CustomDrawerHeader extends StatelessWidget {

  final UserManagerStore userManagerStore = GetIt.I<UserManagerStore>();

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){
        Navigator.of(context).pop();//para que o drawer não fique aberto

        if(userManagerStore.isLoggedIn){
          GetIt.I<PageStore>().setPage(4);
        } else {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => LoginScreen())
        );
        }
      },
      child: Container(
        color: Colors.purple,//cor de fundo do customdrawerHeader
        height: 95,//altura do custodrawer
        padding: const EdgeInsets.symmetric(horizontal: 20),//espaço na esquerda e direita
        child: Row(
          children: <Widget>[
            Icon(Icons.person, color: Colors.white, size: 35,),
            const SizedBox(width: 20,),
            Expanded(//espande a coluna o máximo possível e o texto sabe onde a coluna termina para quebrar
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Observer(builder: (_){
                    return Text(
                      userManagerStore.isLoggedIn//se estiver logado mostra o nome do usuário, senão mostra o texto para acessar
                          ? userManagerStore.user.name
                          : 'Acesse sua conta agora!',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500
                      ),
                    );
                  },
                  ),
                  Text(
                    userManagerStore.isLoggedIn//se usuário estiver logado mostra o email do usuário, senão mostra o clique aqui
                    ? userManagerStore.user.email
                    : 'Clique aqui',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
