import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:xlomobx/components/custom_drawer/error_box.dart';
import 'package:xlomobx/screens/signup/components/field_title.dart';
import 'package:xlomobx/stores/signup_store.dart';

class SignUpScreen extends StatelessWidget {

  final SignupStore signupStore = SignupStore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 32),
              shape: RoundedRectangleBorder(//coloca uma borda no card
                  borderRadius: BorderRadius.circular(16)
              ),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Observer(
                      builder: (_){
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: ErrorBox(//mensagem de erro caso ocorr algum erro para cadastrar, layout fica no errorBox, e mobx fica no sigunpStore
                            message: signupStore.error
                          ),
                        );
                      },
                    ),
                      FieldTitle(
                        title: 'Apelido',
                        subtitle: 'Como aparecerá em seus anúncios',
                      ),
                    Observer(builder: (_){
                      return TextField(
                        enabled: !signupStore.loading, //desabilita o botão enquanto estiver carregando
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Exemplo: João S.",
                            isDense: true,
                            errorText: signupStore.nameError //valida ao digitar
                        ),
                        onChanged: signupStore.setName, //chama o action para obsrevar
                      );
                    }),
                    const SizedBox(height: 16,),
                    FieldTitle(
                      title: 'E-mail',
                      subtitle: 'Enviaremos um e-mail de confirmação',
                    ),
                    Observer(builder: (_){
                      return TextField(
                        enabled: !signupStore.loading, //desabilita o botão enquanto estiver carregando
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Exemplo: joao@gmail.com",
                            isDense: true,
                            errorText: signupStore.emailError //valida ao digitar
                        ),
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,//não corrigir o e-mail o tempo todoo
                        onChanged: signupStore.setEmail, //chama o action para observar
                      );
                    },
                    ),
                    const SizedBox(height: 16,),
                    FieldTitle(
                      title: 'Celular',
                      subtitle: 'Proteja sua conta',
                    ),
                    Observer(builder: (_){
                      return TextField(
                        enabled: !signupStore.loading, //desabilita o botão enquanto estiver carregando
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Exemplo: (99) 99999-9999",
                            isDense: true,
                            errorText: signupStore.phoneError //valida ao digitar
                        ),
                        keyboardType: TextInputType.phone,
                        onChanged: signupStore.setPhone,//chama o action para observar
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly,//somente dígitos passarem
                          TelefoneInputFormatter()//formata certinho no formato de telefone, package brazil_fields
                        ],
                      );
                    },
                    ),
                    const SizedBox(height: 16,),
                    FieldTitle(
                      title: 'Senha',
                      subtitle: 'Use letras, números e caracteres especiais',
                    ),
                    Observer(builder: (_){
                      return TextField(
                        enabled: !signupStore.loading, //desabilita o botão enquanto estiver carregando
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),//colora uma borda arredondada no campo
                            isDense: true,//campo fica menorzinho
                            errorText: signupStore.pass1Error
                        ),
                        obscureText: true,
                        onChanged: signupStore.setPass1,
                      );
                    },
                    ),
                    const SizedBox(height: 16,),
                    FieldTitle(
                      title: 'Confirmar a senha',
                      subtitle: 'Repita sua senha',
                    ),
                    Observer(builder: (_){
                      return TextField(
                        enabled: !signupStore.loading, //desabilita o botão enquanto estiver carregando
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),//colora uma borda arredondada no campo
                            isDense: true,//campo fica menorzinho
                            errorText: signupStore.pass2Error
                        ),
                        obscureText: true,
                        onChanged: signupStore.setPass2,
                      );
                    },
                    ),
                    Observer(builder: (_){
                      return Container(
                        height: 40,
                        margin: const EdgeInsets.only(top: 20, bottom: 12),//espaçamento do campo de senha com o botão
                        child: RaisedButton(
                          color: Colors.orange,
                          disabledColor: Colors.orange.withAlpha(120),
                          child: signupStore.loading ? //se estiver carregando mostra o circulo rodando, senao mostra o texto
                              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white),)
                              : Text('CADASTRAR',),
                          textColor: Colors.white,
                          elevation: 0,
                          onPressed: signupStore.signUpPressed,
                          shape: RoundedRectangleBorder(//coloca uma borda no botão
                              borderRadius: BorderRadius.circular(20)
                          ),
                        ),
                      );
                    },
                    ),
                    Divider(color: Colors.black87,),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Wrap(//caso o texto não caiba na tela vai colocar o 'cadastre-se' para baixo e no centro
                        alignment: WrapAlignment.center,
                        children: <Widget>[
                          const Text(
                            'Já tem uma conta?',
                            style: TextStyle(fontSize: 16,),
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.of(context).pop();//volta para a tela de login
                            },
                            child: Text(
                              'Entrar',
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
