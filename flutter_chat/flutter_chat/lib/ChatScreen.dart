import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutterchat/TestComposer.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'ChatMessage.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final GoogleSignIn googleSignIn = GoogleSignIn();

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>(); //variavel para mostrasr mensagem na tela

  FirebaseUser _currentUser;

  bool _isloading = false;

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.onAuthStateChanged.listen((user){
      setState(() {
        _currentUser = user; //quando ele logar o currentUser vai conter o usuário logado, quando ele deslogar vai conter nulo
      });

    }); //sempre que a autenticação mudar vai chamar essa função anônima com o usuário atual, que pode ser nulo ou o usuário logado
  }

  Future<FirebaseUser> _getUser() async {
    if(_currentUser != null) return _currentUser; //se o currentUser for diferente de nulo eu retorno o currentUser, e se ele for nulo eu vou fazer o login e retorno o user

    try {//try catch vai tratar o erro
      final GoogleSignInAccount googleSignInAccount =
        await googleSignIn.signIn(); //tentou fazer o login com o google e guardou na variável, já pega a conta da pessoa e já consegue pegar o nome, e-mail, foto
      final GoogleSignInAuthentication googleSignInAuthentication =
       await googleSignInAccount.authentication; //vai pegar os dados de autenticação do google, onde tem o token e id de acesso que precisa para fazer a conexão com o firebase
      
      final AuthCredential credential = GoogleAuthProvider.getCredential
        (idToken: googleSignInAuthentication.idToken,
         accessToken: googleSignInAuthentication.accessToken);//desta forma já pega as duas credenciais para fazer o login no firebase

      final AuthResult authResult =
          await FirebaseAuth.instance.signInWithCredential(credential); //vai fazer o login no firebase e guardar o resultado

      final FirebaseUser user = authResult.user; //vai pegar o usuário do firebase para validar o acesso no banco de dados
      return user; //retorna o user depois de pedir o login
    }catch(error){
      return null; //caso dê erro no login, eu retono nulo, por exemplo se o usuário expirar e deslogar, vai ficar nulo e caso o usuário envie uma mensagem vai pedir o login novamente.
    }
  }

  void _sendMessage ({String text, File imgFile}) async {// o abre e fecha chaves é para colocar os parâmetro como não obrigatórios, pois o usuário pode mandar só foto ou só image, não os dois ao mesmo tempo

   final FirebaseUser user = await _getUser(); //vai chamar a função que valida se o usuário está logad, se não estiver logado vai pedir que o usuário faça login antse de enviar a mensagem

    if(user == null){//se o usuário for nulo vai exibir uma mensagem de erro na tela
      _scaffoldkey.currentState.showSnackBar(
        SnackBar(
          content: Text('Não foi possível fazer o login. Tente novamente'),
          backgroundColor: Colors.red,
        )
      );
    }

    Map<String, dynamic> data = {//caso consiga fazer o login vai obter os dados do usuário
    //coloca os dados do usuário
      'uid' : user.uid,
      'sendName' :  user.displayName,
      'sendPhoto' : user.photoUrl,
      'time' : Timestamp.now(),//pega data atual para ordenar por ela as mensagens

    };//cria o mapa data para usar na imagem ou texto

   //coloca imagem caso tenha
    if (imgFile != null){//verifica que foi tirado a foto, ou seja, tem imagem
     StorageUploadTask task = FirebaseStorage.instance.ref().child(//armazena no storage do firebase
       DateTime.now().millisecondsSinceEpoch.toString()//a chave no firebase storage vai ser o milisegundos
     ).putFile(imgFile);//envia a mensagem para o firebase storage

     setState(() {
       _isloading = true; //começou a enviar a mensagem coloca a variável como verdadeira
     });

    StorageTaskSnapshot taskSnapshot = await task.onComplete;//espera a tarefa ser completada e vai trazer várias informações da task que foi concluída
    String url = await taskSnapshot.ref.getDownloadURL();//pega a url da task para depois utilizá-la para exibir
    data['imgUrl'] = url;//guarda a chave da image no Firebase Database
   }

    setState(() {
      _isloading = false; //terminou de enviar a imagem coloca como false
    });

   //coloca o texto caso tenha
    if (text != null) data['text'] = text; //verifica se tem informação no texto para armazenar no mapa
    Firestore.instance.collection('message').add(data); //envia o texto para o Firebase
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,//necessário para mostrar o erro do snackbar na tela
      appBar: AppBar(
        title: Text(

          _currentUser != null ? 'Olá ${_currentUser.displayName}' : 'Chat App'
        ),
        centerTitle: true, // centralizar o título
        elevation: 0,
        actions: <Widget>[
          _currentUser != null ? IconButton(//se o usuário está logado mostra o ícone de sair
            icon: Icon(Icons.exit_to_app),
            onPressed: (){
              FirebaseAuth.instance.signOut();
              googleSignIn.signOut();
              _scaffoldkey.currentState.showSnackBar(
                  SnackBar(//mostra uma mensagem ao usuário após deslogar.
                    content: Text('Você foi desconectado'),
                  )
              );
            },
          ) : Container()// se não tiver usuário logado não mostra ícone
        ],
      ),
    body: Column(
      children: <Widget>[
        Expanded(
          child: StreamBuilder<QuerySnapshot>(//aponta para a coleção e sempre que algo mudar, refaz a tela
            stream: Firestore.instance.collection("message").orderBy('time').snapshots(), //stream vai retornando sempre que tem uma modificação
            builder: (context, snapshot){//snapshot retorna um query snapshot
              switch(snapshot.connectionState){ //switch para verificar se a conexão com o firebase foi feita
                case ConnectionState.none://não retornou nada
                case ConnectionState.waiting://está esperando retornar
                  return Center (
                    child: CircularProgressIndicator(),//irá mostrar um widget de que está pesquisando..
                  );
                default:
                  List<DocumentSnapshot> documents =
                      snapshot.data.documents.reversed.toList();//reversed.to list inverter a lista de documentos

                return ListView.builder(//vai adicionando e carregando os dados, não carrega todos ao mesmo tempo
                    itemCount: documents.length,
                    reverse: true,//mensagens vão aparecer de baixo para cima
                    itemBuilder: (context, index){
                      return ChatMessage(//vai passar os dados do documento, mensagem, a imagem, quem mandou, etc.
                        documents[index].data, 
                        documents[index].data['uid'] == _currentUser?.uid, // verificar se o usuário que está enviando as mensagens é o mesmo que está logado para exibir um à direita (meu) e outro a esquerda.
                      );
                    }
                );
              }
            },

          ),
        ),
       _isloading ? LinearProgressIndicator() : Container(),// enquanto estiver carregando a imagem, irá mostrar uma barra de carregando..
       TextComposer(_sendMessage),
      ],
    ),
    );
  }
}
