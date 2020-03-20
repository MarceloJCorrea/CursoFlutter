import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'gif_page.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search;

  int _offset = 0;

  Future<Map> _getGifs() async {//função assincrona para buscar o json dos gifs
    http.Response response;
    if (_search == null || _search.isEmpty)//retorna um json para usuário que não está pesquisando
      response = await http.get(
          'https://api.giphy.com/v1/gifs/trending?api_key=yVWPNi4WBusiR1rmYUDNM8Xw16G9WsCE&limit=20&rating=G');//traz os 20 melhores gifs
    else//retorna outro json caso usuário esteja pesquisando.
      response = await http.get(
          'https://api.giphy.com/v1/gifs/search?api_key=yVWPNi4WBusiR1rmYUDNM8Xw16G9WsCE&q=$_search&limit=19&offset=$_offset&rating=G&lang=en');//search é o que o usuário digita e top é o tamanho da lista, limit 19 para ficar um espaço para usuário pesquisar

    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();

    _getGifs().then((map) {
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(//image do app bar que pega de um link da internet
            "https://developers.giphy.com/branch/master/static/header-logo-8974b8ae658f704a5b48a2d039b8ad93.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black, //cor de fundo do APPBAR
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Pesquise aqui!", //botão de pesquisa
                labelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0), //cor e fonte do texto do botão de pesquisa
                border: OutlineInputBorder(),
              ),
              style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white), //cor e fonte do botão de pesquisa
              textAlign: TextAlign.center,
              onSubmitted: (text) {
                setState(() {
                  _search = text;
                  _offset = 0;
                });
              },
            ),
          ),
          Expanded(//expande para usar toda a tela
            child: FutureBuilder(//retorna um dado futuro
                future: _getGifs(), //função que retorna o dado futuro
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {//verifica o status da conexão
                    case ConnectionState.waiting: //conexão esperando
                    case ConnectionState.none: //não retorna nada na conexão
                      return Container(
                        //container que mostra o circulo de que está caregando os dados
                        width: 200.0, //altura do circulo
                        height: 200.0, //cumprimento do circulo
                        alignment: Alignment.center, //alinhamento do circulo
                        child: CircularProgressIndicator(//widged que mostra o circulo
                          valueColor: //cor do circulo
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 5.0,
                        ),
                      );
                    default:
                      if (snapshot.hasError) //no caso de erro retorna um container
                        return Container();
                      else
                        return _createGitTable(context,
                            snapshot); //irá retornar os gifs caso dê certo
                  }
                }),
          )
        ],
      ),
    );
  }

  int _getCount(List data) {//função que retorna o tamanho da lista do json quando usuário não pesqui ou adiciona mais 1 caso usuário esteja pesquisando..
    if (_search == null || _search.isEmpty) {
      return data.length;//nao estou pesquisando retorna o caminho inteiro do json
    } else {
      return data.length + 1; //esta pesquisando retorna a lista do json mais 1
    }
  }

  Widget _createGitTable(BuildContext context, AsyncSnapshot snapshot) {//função assincrona para buscar os gifs
    return GridView.builder(
        padding: EdgeInsets.all(10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(//cria o grid com os gifs, coloca quando terá de gif por linha
            crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
        itemCount: _getCount(snapshot.data["data"]), //quantidade de gifs a exibir que virá do json
        itemBuilder: (context, index) {
          if (_search == null || index < snapshot.data["data"].length) {//verifica se nao estou pesquisando ou se este não é o ultimo item da lista
            return GestureDetector(//retona o a lista do gif inteira
              child: FadeInImage.memoryNetwork(//traz a imagem de uma forma mais suave
                  placeholder: kTransparentImage, //image transparente enquanto gif nao carrega
                  image: snapshot.data["data"][index]["images"]["fixed_height"]["url"],//busca os dados do json,
                  height: 300.0,
                  fit: BoxFit.cover,
              ),
              onTap: (){//o que acontece quando usuário clica no botão
                Navigator.push(context, //para ir para a próxima tela
                  MaterialPageRoute(builder: (context) => GifPage(snapshot.data["data"][index]))//cria uma rota para a tela do GifPage
                );
              },
              onLongPress: (){//vai dar opção de compartilhar quando segurar o gif na tela
                Share.share(snapshot.data['data'][index]['images']['fixed_height']['url']);
              },
            );
          } else//retorna o icone para carregar mais
            return Container(
              child: GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,//centraliza o botão carregar mais
                  children: <Widget>[
                    Icon(Icons.add, color: Colors.white, size: 70.0),//icone e aparencia do botão carregar mais..
                    Text(
                      "Carregar mais...",//botão para carregar mais Gifs
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.0,
                      ),
                    )
                  ],
                ),
                onTap: (){
                  setState(() {
                    _offset +=19;
                  });
                },
              ),
            );
        });
  }
}
