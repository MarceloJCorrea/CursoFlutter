import 'package:flutter/material.dart';
import 'dart:async'; //permite realizar consultar assincronas, que não fica aguardando respota
import 'package:http/http.dart' as http; //permite fazer requisições ao servidor
import 'dart:convert'; //converte o json

const request = "https://api.hgbrasil.com/finance?format=json-cors&key=837a3cc4";

void main() async {
  //função main é assincrona com o 'async'

  runApp(MaterialApp(
    title: 'Conversor de Moeda',
    home: Home(),
    theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white), //definindo um tema para o app inteiro
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController(); //como o controlador nao muda pode por o final
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double dolar;
  double euro;

  void _realChanged(String text) {//função que será chamada quando clicar no botão

    if(text.isEmpty){//apaga o conteúdo do texto
      _clearAll();
      return;
    }
    double real = double.parse(text); //converte o texto para double e guarda na variavel
    dolarController.text = (real / dolar).toStringAsFixed(2); //tostringasfixed fica a casa decimal em 2
    euroController.text = (real / euro).toStringAsFixed(2); //coloca no controlador do text a conersão para euro
  }

  void _dolarChanged(String text) {
    if(text.isEmpty){
      _clearAll();
      return;
    }

    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2); //this.dolar pega a variavel de dentro da função o outro pega de fora. Converte pra real
    euroController.text = (dolar * this.dolar * euro).toStringAsFixed(2); //converte para real e depois multiplica para euro
  }

  void _euroChanged(String text) {
    if(text.isEmpty){
      _clearAll();
      return;
    }

    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2); //converte para real
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2); //converte pra real depois divide pelo dolar para ir para a cotação em dolar
  }

  void _clearAll (){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //usado para criar o layout com o APP Bar, a barra do APP.
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
            "\$ Conversor \$"), // A \$ é utilizada para por o texto $ no texto, se não por, ele entende como variavel
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
          //retorna um mapa futuro, que são dados que vão retornar ainda e não sabemos os valores
          future: getData(),
          builder: (context, snapshot) {
            //snapshot tira uma foto da consulta
            switch (snapshot.connectionState) {
              //verifica o status da consulta
              case ConnectionState.none: //se não retorna nada faz isso
              case ConnectionState.waiting: //se está esperando retorno dá mensagem
                return Center(
                  child: Text(
                    "Carregando Dados..",
                    style: TextStyle(color: Colors.amber, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                );
              default:
                if (snapshot.hasError) {//se ocorre erro dá erro
                  return Center(
                    child: Text(
                      "Erro ao Carregar Dados :(",
                      style: TextStyle(color: Colors.amber, fontSize: 25.0),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else // se der certo vai carregar as informaões no layout
                  dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];

                return SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.stretch, //usa o espaço da tela
                    children: <Widget>[
                      Icon(Icons.monetization_on, //icone de monetização
                          size: 150.0,
                          color: Colors.amber), //coloca o estilo do
                      Divider(), //insere um espaçamento
                      buildTextField("Reais", "R\$ ", realController,
                          _realChanged), //chama a função do widget texto
                      Divider(),
                      buildTextField(
                          "Dolares", "US\$ ", dolarController, _dolarChanged),
                      Divider(),
                      buildTextField(
                          "Euros", "€ ", euroController, _euroChanged),
                    ],
                  ),
                );
            }
          }),
    );
  }
}

Widget buildTextField(
    String label, String prefix, TextEditingController c, Function f) {
  //função que monta o widget de texto
  return TextField(
    controller: c, //passa o controlador para cada TextField
    decoration: InputDecoration(
        //insere decoração no texto
        labelText: label, //insere o label do texto
        labelStyle: TextStyle(color: Colors.amber), //insere a cor do texto
        border: OutlineInputBorder(), //insere a borda do texto
        prefixText: prefix),
    style: TextStyle(color: Colors.amber, fontSize: 25.0),
    onChanged: f,
      keyboardType: TextInputType.numberWithOptions(decimal: true), //coloca o insert no campo como numérico, e no IOS abre a opção de por decimal e o (.) entre os números
  );
}
