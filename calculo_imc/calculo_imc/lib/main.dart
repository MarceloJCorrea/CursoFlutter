import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController weightController =
      TextEditingController(); //controlador da altura
  TextEditingController heightController =
      TextEditingController(); //controlador do peso

  GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); //usado para criar o formulario de validação

  String infoText = 'Informe seu dados!'; //variavel do texto informativo

  void _resetField() {
    setState(() {// set state atualiza os campos do formulario
      weightController.text = ""; //reseta a altura
      heightController.text = ""; //reseta o peso
      infoText = 'Informe seu dados!'; //reseta o texto informativo
      _formKey = GlobalKey<FormState>(); //reseta o formulario
    });
  }

  void _calculate() {
    setState(() {
      double weight = double.parse(weightController
          .text); //cria a variavel da altura e o double.parte converte para double o texto
      double height = double.parse(heightController.text) / 100;
      double imc = weight / (height * height); // faz o calculo do IMC

      if (imc < 18.6) {//faz a validação do IMC e mostra na tela o resultado
        infoText = "Abaixo do Peso (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 18.6 && imc <= 24.9) {
        infoText = "Peso ideal (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 24.9 && imc <= 29.9) {
        infoText = "Levemente acima do Peso (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 29.9 && imc <= 34.9) {
        infoText = "Obesidade Grau 1 (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 34.9 && imc <= 39.9) {
        infoText = "Obesidade Grau 2 (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 40) {
        infoText = "Obesidade Grau 3 (${imc.toStringAsPrecision(4)})";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(//cria a barra do aplicativo
        title: Text("Calculadora IMC"), //coloca o nome
        centerTitle: true, //coloca no centro
        backgroundColor: Colors.green, //coloca a cor verde
        actions: <Widget>[
          IconButton(
            //cria o icone
            icon: Icon(Icons.refresh), //cria o icone refresh
            onPressed:
                (_resetField), //chama a função que reseta quando clica no botão
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(//cria o scroll do APP, evita dar erro de teclado em cima
          padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0,0.0), //coloca margens no top, embaixo e dos lados
          child: Form(//usado para fazer as validações do form
            key: _formKey,
            child: Column(//cia coluna que pode ser criados texto, botão tudo dentro..
              children: <Widget>[
                Icon(Icons.person_outline,
                    size: 120.0,
                    color: Colors.green), //cria o icone do personagem na tela
                TextFormField( //cria um texto que faz validação, o TextField não valida
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(//cria o label e a cor do texto do label
                    labelText: "Peso (Kg)",
                    labelStyle: TextStyle(color: Colors.green),
                  ),
                  style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.green), //cor do texto digitado
                  textAlign: TextAlign
                      .center, //centraliza o Texto que será digitado, não o label
                  controller: weightController,
                  validator: (value) {//faz a validação do Peso
                    if (value.isEmpty) return "Insira seu Peso";
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Atura (cm)",
                    labelStyle: TextStyle(color: Colors.green),
                  ),
                  style: TextStyle(fontSize: 25.0, color: Colors.green),
                  textAlign: TextAlign.center,
                  controller: heightController,
                  validator: (value) {
                    if (value.isEmpty) return "Insira sua Altura";
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 10.0,
                      bottom: 10.0), //só põe margem no topo e embaixo
                  child: Container(//container para por o botão calcular e o texto ajustados os espaços entre eles
                      height: 50.0,
                      width: 1000.0,
                      child: RaisedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            //só calcula se tiver validado o form
                            _calculate();
                          }
                        },
                        child: Text(//texto do botão, põe cor e tamanho no botão
                          "Calcular",
                          style: TextStyle(color: Colors.white, fontSize: 25.0),
                        ),
                        color: Colors.green,
                      )),
                ),
                Text(
                  infoText,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.green, fontSize: 25.0),
                ),
              ],
            ),
          )
      ),
    );
  }
}
