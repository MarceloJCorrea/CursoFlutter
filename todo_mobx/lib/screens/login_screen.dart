import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:todomobx/stores/login_store.dart';
import 'package:todomobx/widgets/custom_icon_button.dart';
import 'package:todomobx/widgets/custom_text_field.dart';

import 'list_screen.dart';

class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  LoginStore loginStore;

  ReactionDisposer disposer;//libera memória do autorun

  @override
  void didChangeDependencies() {//para colocar um autorun dentro do stateful é dentro do didChagedDependencies
    super.didChangeDependencies();//não esquece de dar o super

    loginStore = Provider.of<LoginStore>(context); //conseguimos acessar o loginSotre que está declarado no main aqui na login screen

    disposer = autorun((_){//dentro do disposer para que seja fechado depois no dispose
      if(loginStore.loggedIn)//se o login der certo vai trocar de tela
        Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => ListScreen()
            )
        );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(32),
          child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 16,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Observer(
                      builder: (_){
                        return CustomTextField(
                          hint: 'E-mail',
                          prefix: Icon(Icons.account_circle),
                          textInputType: TextInputType.emailAddress,
                          onChanged: loginStore.setEmail, //conforme for digitando o campo já vai ter a ação do observable
                          enabled: !loginStore.loading, //quadno estiver carregando o login bloqueia o campo de email
                        );
                      },
                    ),
                    const SizedBox(height: 16,),
                    Observer(
                      builder: (_){
                        return CustomTextField(
                          hint: 'Senha',
                          prefix: Icon(Icons.lock),
                          obscure: !loginStore.passwordVisible,// ! é para inverter se o password for vísivel eu quero estar obscuro
                          onChanged: loginStore.setPassword, //conforme for digitando o campo já vai ter a ação do observable
                          enabled: !loginStore.loading,//quando estiver carregando bloqueia campo de senha
                          suffix: CustomIconButton(
                            radius: 32,
                            iconData: loginStore.passwordVisible ? Icons.visibility_off : Icons.visibility, //ícone irá mudar conforme o campo estiver para aparecer a senha ou não
                            onTap: loginStore.togglePasswordVisibility,//mostra ou não a senha
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16,),
                    Observer(
                      builder: (_){
                        return SizedBox(
                          height: 44,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: loginStore.loading ? //se e estiver carregando vai mostrar um circulo girando, se terminar de carregar vai mostrar o Login ou mudar de tela
                            CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white))
                                : Text('Login'),
                            color: Theme.of(context).primaryColor,
                            disabledColor: Theme.of(context).primaryColor.withAlpha(100),
                            textColor: Colors.white,
                            onPressed: loginStore.loginPressed,//chama a função do login_store
                          ),
                        );
                      }
                    )
                  ],
                ),
              )
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {//libera a memória do autorun para não deixar ele ficar rodando consumidon memória
    disposer();
    super.dispose();
  }

}
