import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutterchat/TestComposer.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  void _sendMessage ({String text, File imgFile}) async {// o abre e fecha chaves é para colocar os parâmetro como não obrigatórios, pois o usuário pode mandar só foto ou só image, não os dois ao mesmo tempo

   Map<String, dynamic> data = {};//cria o mapa data para usar na imagem ou texto

    if (imgFile != null){//verifica que foi tirado a foto, ou seja, tem imagem
     StorageUploadTask task = FirebaseStorage.instance.ref().child(//armazena no storage do firebase
       DateTime.now().millisecondsSinceEpoch.toString()//a chave no firebase storage vai ser o milisegundos
     ).putFile(imgFile);//envia a mensagem para o firebase storage

    StorageTaskSnapshot taskSnapshot = await task.onComplete;//espera a tarefa ser completada e vai trazer várias informações da task que foi concluída
    String url = await taskSnapshot.ref.getDownloadURL();//pega a url da task para depois utilizá-la para exibir
    data['imgUrl'] = url;//guarda a chave da image no Firebase Database
   }

    if (text != null) data['text'] = text; //verifica se tem informação no texto para armazenar no mapa
    Firestore.instance.collection('message').add(data); //envia o texto para o Firebase
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Olá"),
        elevation: 0,
      ),
    body: TextComposer(_sendMessage),
    );
  }
}
