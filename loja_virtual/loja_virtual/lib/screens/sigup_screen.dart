import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {

  final _formKey = GlobalKey<FormState>();//cria a variável para usar no fomularío e validar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Criar conta"),
          centerTitle: true,
        ),
        body: Form(//cria um formulário para fazer a validação dos dados de acesso
          key: _formKey,//chama o formulário para validar
          child: ListView(
            padding: EdgeInsets.all(16.0),
            children: <Widget>[
              TextFormField(//cria o campo na tela que vai receber e validar o e-mail
                decoration: InputDecoration(
                  hintText: "Nome Completo",
                ),
                validator: (text){
                  if(text.isEmpty ) return "Nome inválido!";
                  else
                    return text;
                },
              ),
              SizedBox(height: 16.0,),//cria um espaço entre o nome e o e-mail
              TextFormField(//cria o campo na tela que vai receber e validar o e-mail
                decoration: InputDecoration(
                  hintText: "E-mail",
                ),
                keyboardType: TextInputType.emailAddress,//chama o teclado para receber dados do tipo e-mail, vai ter o @ para selecionar
                validator: (text){
                  if(text.isEmpty || !text.contains("@")) return "E-mail inválido!";
                  else
                    return text;
                },
              ),
              SizedBox(height: 16.0,),//cria um espaço entre o e-mail e a senha
              TextFormField(//cria o campo de texto que vai receber e validar a senha
                decoration: InputDecoration(
                  hintText: "Senha",
                ),
                obscureText: true,//não mostra a senha
                validator: (text){
                  if(text.isEmpty || text.length < 6) return "Senha inválido!";
                  else
                    return text;
                },
              ),
              SizedBox(height: 16.0,),//cria um espaço entre a senha e o endereço
              TextFormField(//cria o campo de texto que vai receber e validar a senha
                decoration: InputDecoration(
                  hintText: "Endereço",
                ),
                validator: (text){
                  if(text.isEmpty) return "Endereço inválido!";
                  else
                    return text;
                },
              ),
              SizedBox(height: 16.0,),//espaço entre a senha e o botão esqueci minha senha
              SizedBox(//coloca o botão numa altura um pocuo maior de 44
                height: 44.0,
                child: RaisedButton(
                  onPressed: (){
                    if(_formKey.currentState.validate()) return;
                  },
                  child: Text(
                    "Criar conta",
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
        )
    );
  }
}
