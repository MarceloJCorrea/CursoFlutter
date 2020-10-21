import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerenteloja/blocs/login_bloc.dart';
import 'package:gerenteloja/widgets/input_field.dart';
import 'home.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final _loginBloc = LoginBloc();


  @override
  void initState() {
    super.initState();

    _loginBloc.outState.listen((state) {
      switch(state){
        case LoginState.SUCESS:
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder : (context) => Home())
          );
          break;
        case LoginState.FAIL:
          showDialog(context: context, builder: (contxt) => AlertDialog(
            title: Text("Erro"),
            content: Text("Você não possui o previlégio necessário"),
          ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: StreamBuilder<LoginState>(
        stream: _loginBloc.outState,
        initialData: LoginState.LOADING,
        builder: (context, snapshot) {
          switch (snapshot.data){
            case LoginState.LOADING://caso esteja carregando vai mostrar a bolinha rodando com cor rosa
              return Center(child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.pinkAccent),),);
            case LoginState.FAIL://nesses três casos abaixo se entrar vai retornar o Stack, Fail mostra diálogo, Sucess faz o login e atualiza a tela
            case LoginState.SUCESS:
            case LoginState.IDLE:
            return Stack(
              alignment: Alignment.center,//só isso não muda nada na tela, pois a stack se adapta a tela, tem que por o Contairner() antes do SingleChildScrollView
              children: <Widget>[
                Container(),
                SingleChildScrollView(//utilizado para que ao clicar nos campos de senha, possamos mexer na tela para cima e para baixo
                  child: Container(
                    margin: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,//estica tudo no eixo horizontal
                      children: <Widget>[
                        Icon(
                          Icons.store_mall_directory,
                          size: 160,
                          color: Colors.pinkAccent,
                        ),
                        InputField(
                          icon: Icons.person_outline,
                          hint: "Usuário",
                          obscure: false,
                          stream: _loginBloc.outEmail,//saida do bloc do email
                          onChanged: _loginBloc.changeEmail,//validação em tempo real do email se contem o @
                        ),
                        InputField(
                          icon: Icons.lock_outline,
                          hint: "Senha",
                          obscure: true,
                          stream: _loginBloc.outPassword,//saida do bloc da senha
                          onChanged: _loginBloc.changePassword,//validação da senha em tempo real se tem mais de 4 caracteres
                        ),
                        SizedBox(height: 32,),
                        StreamBuilder<bool>(
                            stream: _loginBloc.onSubmitValid,
                            builder: (context, snapshot) {
                              return SizedBox(
                                height: 50,
                                child: RaisedButton(
                                  color: Colors.pinkAccent,
                                  child: Text(
                                      'Entrar'
                                  ),
                                  onPressed: snapshot.hasData ? _loginBloc.submit : null, //submit sem parentes pois é a função e não o resultado//caso o stream onSubmitValid retorne true, libera o botão, senão o botão fica desabilitado
                                  textColor: Colors.white,
                                  disabledColor: Colors.pinkAccent.withAlpha(140),//cor do botão desabilitado
                                ),
                              );
                            }
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          } return null;
        }
      ),
    );
  }

  @override
  void dispose() {//libera a memória do aparelho
    _loginBloc.dispose();
    super.dispose();
  }


}

