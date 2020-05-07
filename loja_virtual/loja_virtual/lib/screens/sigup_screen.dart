import 'package:flutter/material.dart';
import 'package:lojavirtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _passController = TextEditingController();
  final _emailController = TextEditingController();
  final _addreesController = TextEditingController();

  final _formKey = GlobalKey<FormState>();//cria a variável para usar no fomularío e validar

  final _scaffoldKey = GlobalKey<ScaffoldState>();//declara a key do scaffold para usar o snackbar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,//chama a key do scaffold
        appBar: AppBar(
          title: Text("Criar conta"),
          centerTitle: true,
        ),
        body: ScopedModelDescendant<UserModel>(//coloca o Form dentro do ScopedModelDescedent para que os dados sejam atualizados no Form
          builder: (context, child, model) {
            if(model.isLoading)//se modelo está carregando aparece o circularprogrees indicator
              return Center(child: CircularProgressIndicator(),);
            else
              return Form( //cria um formulário para fazer a validação dos dados de acesso
                key: _formKey, //chama o formulário para validar
                child: ListView(
                  padding: EdgeInsets.all(16.0),
                  children: <Widget>[
                    TextFormField( //cria o campo na tela que vai receber e validar o e-mail
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: "Nome Completo",
                      ),
                      /*validator: (text) {
                        if (text.isEmpty) return "Nome inválido!";

                      },*/
                    ),
                    SizedBox(height: 16.0,),
                    //cria um espaço entre o nome e o e-mail
                    TextFormField( //cria o campo na tela que vai receber e validar o e-mail
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: "E-mail",
                      ),
                      keyboardType: TextInputType.emailAddress,
                      //chama o teclado para receber dados do tipo e-mail, vai ter o @ para selecionar
                     /* validator: (text) {
                        if (text.isEmpty || !text.contains("@")) return "E-mail inválido!";
                        else
                          return "";
                      },*/
                    ),
                    SizedBox(height: 16.0,),
                    //cria um espaço entre o e-mail e a senha
                    TextFormField( //cria o campo de texto que vai receber e validar a senha
                      controller: _passController,
                      decoration: InputDecoration(
                        hintText: "Senha",
                      ),
                      obscureText: true, //não mostra a senha
                      /*validator: (text) {
                        if (text.isEmpty || text.length < 6) return "Senha inválido!";
                        else
                          return '';
                      },*/
                    ),
                    SizedBox(height: 16.0,), //cria um espaço entre a senha e o endereço
                    TextFormField( //cria o campo de texto que vai receber e validar o endreço
                      controller: _addreesController,
                      decoration: InputDecoration(
                        hintText: "Endereço",
                      ),
                      /*validator: (text) {
                        if (text.isEmpty) return "Endereço inválido!";
                        else
                          return "";
                      },*/
                    ),
                    SizedBox(height: 16.0,),//espaço entre a senha e o botão esqueci minha senha
                    SizedBox( //coloca o botão numa altura um pocuo maior de 44
                      height: 44.0,
                      child: RaisedButton(
                        child: Text("Criar conta",
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        color: Theme.of(context).primaryColor, //cor do botão
                        textColor: Colors.white, //cor do texto do botão
                        onPressed: () {
                          if (_formKey.currentState.validate()){

                            Map<String, dynamic> userData = {//cria um mapa que recebe os dados dos controladores e guarda no UserData, não armazena a senha, pois ela não pode ser salva no firebase por questão de segurança
                              'name': _nameController.text,
                              'email': _emailController.text,
                              'addrees': _addreesController.text
                            };

                            model.signUp(
                                userData: userData,
                                pass: _passController.text,
                                onSuccess: _onSuccess,
                                onFail: _onFail
                            );
                          }
                        },
                      ),
                    )
                  ],
                ),
              );
          },
        )
    );
  }

  void _onSuccess(){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Usuário criado com sucesso!"),
          backgroundColor: Theme.of(context).primaryColor,
          duration: Duration(seconds: 2),
        )
    );
    Future.delayed(Duration(seconds: 2)).then((_){
      Navigator.of(context).pop();
    });
  }

  void _onFail(){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Falha ao criar o usuário"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        )
    );
  }
}