import 'package:flutter/material.dart';
import 'package:lojavirtual/models/user_model.dart';
import 'package:lojavirtual/screens/sigup_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();//cria a variável para usar no fomularío e validar

  final _passController = TextEditingController();
  final _emailController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();//declara a key do scaffold para usar o snackbar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Entrar"),
          centerTitle: true,
          actions: <Widget>[
            FlatButton(
              child: Text(
                "Criar conta",
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: (){
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context)=>SignUpScreen())
                );
              },
            )
          ],
        ),
        body: ScopedModelDescendant<UserModel>(//o que está abaixo do scopedmodel será reconstruída
            builder: (context, child, model){
              if(model.isLoading) //verifica se está carregando, se estiver será mostrado uma bolinha carregando, senão vai atualizar os dados do Form
                return Center(child: CircularProgressIndicator(),);
              return Form(//cria um formulário para fazer a validação dos dados de acesso
                key: _formKey,//chama o formulário para validar
                child: ListView(
                  padding: EdgeInsets.all(16.0),
                  children: <Widget>[
                    TextFormField(//cria o campo na tela que vai receber e validar o e-mail
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: "E-mail",
                      ),
                      keyboardType: TextInputType.emailAddress,//chama o teclado para receber dados do tipo e-mail, vai ter o @ para selecionar
                      validator: (text){
                        if(text.isEmpty || !text.contains("@")) return "E-mail inválido!";
                        else
                          return null;
                      },
                    ),
                    SizedBox(height: 16.0,),//cria um espaço entre o e-mail e a senha
                    TextFormField(//cria o campo de texto que vai receber e validar a senha
                      controller: _passController,
                      decoration: InputDecoration(
                        hintText: "Senha",
                      ),
                      obscureText: true,//não mostra a senha
                      validator: (text){
                        if(text.isEmpty || text.length < 6) return "Senha inválido!";
                        else
                          return null;
                      },
                    ),
                    SizedBox(height: 16.0,),//espaço entre a senha e o botão esqueci minha senha
                    Align(//configura o alinhamento a direita para que tudo abaixo seja alinhado a direita
                      alignment: Alignment.centerRight,
                      child: FlatButton(//cria o botão
                        onPressed: (){
                          if(_emailController.text.isEmpty)
                            _scaffoldKey.currentState.showSnackBar(
                                SnackBar(content: Text("Insira seu e-mail"),
                                  backgroundColor: Colors.redAccent,
                                  duration: Duration(seconds: 2),
                                )
                            );
                          else{

                            model.recoverPass(_emailController.text);
                            _scaffoldKey.currentState.showSnackBar(
                                SnackBar(content: Text("Confira seu e-mail"),
                                  backgroundColor: Theme.of(context).primaryColor,
                                  duration: Duration(seconds: 2),
                                )
                            );
                          }
                        },
                        child: Text(
                          "Esqueci minha senha",
                          textAlign: TextAlign.right,//força o alinhamento a direita
                        ),
                        padding: EdgeInsets.zero, //tira o padding que foi setado para que o botão enconte a direita e use o espaço
                      ),
                    ),
                    SizedBox(height: 16.0,),//espaço entre a senha e o botão entrar
                    SizedBox(//coloca o botão numa altura um pocuo maior de 44
                      height: 44.0,
                      child: RaisedButton(
                        onPressed: (){
                          if(_formKey.currentState.validate()){

                          }
                          model.signIn(
                              email: _emailController.text,
                              pass: _passController.text,
                              onSuccess: _onSuccess,
                              onFail: _onFail);
                        },
                        child: Text(
                          "Entrar",
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        color: Theme.of(context).primaryColor,//cor do botão
                        textColor: Colors.white,//cor do texto do botão
                      ),
                    )
                  ],
                ),
              );
            }
        )
    );
  }

  void _onSuccess(){
    Navigator.of(context).pop();

  }

  void _onFail(){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Falha ao realizar login"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        )
    );
  }
}
