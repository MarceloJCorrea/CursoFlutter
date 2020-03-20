import 'dart:async';
import 'dart:convert';
import 'dart:io';

import "package:flutter/material.dart";
import "package:path_provider/path_provider.dart";

void main() {
  runApp(MaterialApp(home: Home()));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _toDoController = TextEditingController();

  List _todoList = [];
  Map<String, dynamic> _lastRemoved; //armazena cada tarefa
  int _lastRemovedPos; //qual posição foi removida, se remove da posição 2 volta para a posição 2

  @override
  void initState() {//inicia o APP carregando os dados atualizados
    super.initState();

    _readData().then((data) {//then chama uma função assim que obter dados do read
      setState(() {
        _todoList = json.decode(data);
      });
    }
    );
  }

  void _addToDo() {
    setState(() {
      Map<String, dynamic> newTodo =
          Map(); //cria o mapa para adicionar na lista como string
      newTodo["title"] =
          _toDoController.text; //coloca o texto da lista no texto
      _toDoController.text = ""; //reseta o texto do controlador
      newTodo["Ok"] = false; //o check da lista sempre entra como não feito
      _todoList.add(newTodo); //adciona o elemento na lista
      _saveData(); //salva os dados na lista do json
    });
  }

  Future<Null> _reflesh() async{//cria o reflash na tela e retorna um dado futuro
    await Future.delayed(Duration(seconds: 1));//duração da atualização da lista na tela

    setState(() {
      _todoList.sort((a, b){//ordena a lista por itens concluídos\não concluídos
        if(a["Ok"] && !b["Ok"]) return 1;
        else if (!a["Ok"] && b["Ok"]) return -1;
        else return 0;
    });
      _saveData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(//cria o app bar do APP
        title: Text("Lista de Tarefas"), //coloca texto no appbar
        centerTitle: true, //coloca centralizado
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(//cria coluna
          children: <Widget>[
        Container(//container que vai ter o texto e o botão
          padding: EdgeInsets.fromLTRB(17.0, 1.00, 7.00,
              1.00), //coloca margens no container que vai ter o texto e botão
          child: Row(//cria linha na coluna
            children: <Widget>[
              Expanded(//expande a linha para usar o o espaço inteiro do padding
                child: TextField(
                  controller: _toDoController,
                  decoration: InputDecoration(
                    //coloca a decoração do label, cor e o texto.
                    labelText: "Nova Tarefa",
                    labelStyle: TextStyle(color: Colors.blueAccent),
                  ),
                ),
              ),
              RaisedButton(
                //cria o botão ADD
                color: Colors.blueAccent,
                child: Text("ADD"),
                textColor: Colors.white,
                onPressed: () {
                  _addToDo();
                },
              )
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(onRefresh: _reflesh,//cria o reflesh na lista e chama a função que trata o dados e ordena
                 child: ListView.builder(//cria uma lita view
                 padding: EdgeInsets.only(top: 10.0),
                 itemCount: _todoList.length, //tamanho da lista
                 itemBuilder: buildItem) ),
            ),
      ]),
    );
  }

  Widget buildItem(context, index) {
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-0.9, 0.0), //coloca o icone para a esquerda
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(//lista com um check de feito ou não
        title: Text(_todoList[index]["title"]), //texto da lista
        value: _todoList[index]["Ok"], //check do ok da lista de feito ou não
        secondary: CircleAvatar(//coloca um icone no check de feito ou não
          child: Icon(_todoList[index]["Ok"]
                  ? Icons.check
                  : Icons.error //icone de check ou error
              ),
        ),
        onChanged: (c) {//marca true o false o check e atualiza o icone
          setState(() {//atualiza a lista quando marca ou desmarca o check
            _todoList[index]["Ok"] = c; //atualiza o elemento do check da lista
            _saveData(); //salva os dados (convertido no json) quando check uma tarefa na lista.
          });
        },
      ),
      onDismissed: (direction) {
        setState(() {
          _lastRemoved = Map.from(_todoList[index]);
          _lastRemovedPos = index;
          _todoList.removeAt(index);
          _saveData();

          final snack = SnackBar(//Cria a barra com a informação de que foi removido a tarefa
            content: Text("Tarefa \"${_lastRemoved}\" removida"),//texto que aparece quando a tarefa é removida
            action: SnackBarAction(
                label: "Desfazer",//Texto que aparece com a opção para desfazer a exclusão da tarefa
                onPressed: () {//quando pressiona o desfazer volta a tarefa removida
                  setState(() {
                    _todoList.insert(_lastRemovedPos, _lastRemoved);
                    _saveData();
                  });
                }
                ),
            duration: Duration(seconds: 10),//duração que a snack bar do desfazer ficará na tela
          );
          Scaffold.of(context).removeCurrentSnackBar();//correção para o desfazer não aparecer para outros itens.
          Scaffold.of(context).showSnackBar(snack);//mostra a snack bar na tela
        });
      },
    );
  }

  Future<File> _getFile() async {//retorna um arquivo
    final directory = await getApplicationDocumentsDirectory(); //retorna o diretório do documento padrão do IO ou Android
    return File("${directory.path}/data.jason"); //pega o caminho do diretorio e o arquivo que é o data.jason
  }

  Future<File> _saveData() async {//salva dados no arquivo
    String data = json.encode(_todoList); //transforma a lista em um json e armazena na String data
    final file = await _getFile(); //await espera o arquivo, não é instantaneo
    return file.writeAsString(data); // vai ler o arquivo data
  }

  Future<String> _readData() async {//ler os dados do arquivo
    try {//se der certo retorno os dados do arquivo, se não retorna null
      final file = await _getFile();

      return file.readAsString();
    } catch (e) {
      return null;
    }
  }
}
