import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:xlomobx/components/custom_drawer/error_box.dart';
import 'package:xlomobx/screens/signup/signup_screen.dart';
import 'package:xlomobx/stores/login_store.dart';

class LoginScreen extends StatelessWidget {

  final LoginStore loginStore = LoginStore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entrar'),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(//para não dar o overflow do tamanho do card, caso a tela do celular seja pequena
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 32),//o card fica afastado na esquerda e direita
              shape: RoundedRectangleBorder(//coloca uma borda no card
                borderRadius: BorderRadius.circular(16)
              ),
              elevation: 8,//sombra nas bordas
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Acessar com E-mail',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[900],
                      ),
                    ),
                    Observer(builder: (_){
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ErrorBox(
                          message: loginStore.error
                        ),
                      );
                    },),
                    Padding(
                      padding: const EdgeInsets.only(left: 3, bottom: 4, top: 8),
                      child: Text(
                        'E-mail',
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Observer(builder: (_){
                      return TextField(
                        enabled: !loginStore.loading,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),//colora uma borda arredondada no campo
                            isDense: true,//campo fica menorzinho
                            errorText: loginStore.emailError,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: loginStore.setEmail,
                      );
                    },
                    ),
                    const SizedBox(height: 16,),//coloca um espaçamento entre os campos
                  Padding(
                    padding: const EdgeInsets.only(left: 3, bottom: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,//espaço entre os elementos
                      children: <Widget>[
                        Text(
                          'Senha',
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        GestureDetector(
                          child: Text(
                            'Esqueceu sua senha',
                            style: TextStyle(
                              decoration: TextDecoration.underline,//tracinho embaixo do texto
                              color: Colors.purple
                            ),
                          ),
                          onTap: (){},
                        ),
                      ],
                    ),
                  ),
                    Observer(builder: (_){
                      return TextField(
                        enabled: !loginStore.loading,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),//colora uma borda arredondada no campo
                          isDense: true,//campo fica menorzinho
                          errorText: loginStore.passwordError,
                        ),
                        obscureText: true,
                        onChanged: loginStore.setPassword,
                      );
                    },
                    ),
                    const SizedBox(height: 16,),//coloca um espaçamento entre os campos
                    Container(
                      height: 40,
                      margin: const EdgeInsets.only(top: 20, bottom: 12),//espaçamento do campo de senha com o botão
                      child: Observer(builder: (_){
                        return RaisedButton(
                          color: Colors.orange,
                          disabledColor: Colors.orange.withAlpha(120),
                          child: loginStore.loading ?
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          )
                          : Text('ENTRAR',),
                          textColor: Colors.white,
                          elevation: 0,
                          onPressed: loginStore.loginPressed,
                          shape: RoundedRectangleBorder(//coloca uma borda no botão
                              borderRadius: BorderRadius.circular(20)
                          ),
                        );
                      },
                      ),
                    ),
                    Divider(color: Colors.black87,),//linha dividindo
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Wrap(//caso o texto não caiba na tela vai colocar o 'cadastre-se' para baixo e no centro
                        alignment: WrapAlignment.center,
                        children: <Widget>[
                          const Text(
                            'Não tem uma conta?',
                            style: TextStyle(fontSize: 16,),
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => SignUpScreen())
                              );
                            },
                            child: Text(
                              'Cadastre-se',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.purple,
                                fontSize: 16,
                              ) ,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
