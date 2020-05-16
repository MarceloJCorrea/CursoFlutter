import 'package:flutter/material.dart';
import 'package:lojavirtual/models/cart_model.dart';
import 'package:lojavirtual/screens/HomeScreen.dart';
import 'package:scoped_model/scoped_model.dart';

import 'models/user_model.dart';

void main() => runApp(MyApp());

//coloca o ScopedModel como widget principal para que ele possa ser chamado em qualquer lugar do app.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(//dentro do <> coloca o tipo do ScopedModel
        model: UserModel(),//chama o model para ser usado em qualquer lugar do app
        child: ScopedModelDescendant<UserModel>(//refaz o carrinho caso troque de usuario, tem que especificar o tipo do modelo <UserModel> para que ele encontre o scoped model correto
          builder: (context, child, model){
            return ScopedModel<CartModel>(
              model: CartModel(model),//nosso carrinho precisa ter acesso ao usuário atual, usuário atual não precisa de acesso ao carrinho
              child: MaterialApp(
                  title: 'Loja Flutter',
                  theme: ThemeData(
                      primarySwatch: Colors.blue,
                      primaryColor: Color.fromARGB(255, 4, 125, 141)
                  ),
                  debugShowCheckedModeBanner: false,
                  home: HomeScreen()
              ),
            );
          },
        )
    );
  }
}