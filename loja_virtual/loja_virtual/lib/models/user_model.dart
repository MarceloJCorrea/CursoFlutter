import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

//Model é um objeto que guarda o estado do usuário atual e as funções que modificam esse estado, conforme vai modificando o estado ele vai influenciando o layout do app.
class UserModel extends Model{

 FirebaseAuth _auth = FirebaseAuth.instance;//cria a variavel para pegar as credenciais do usuário

 FirebaseUser firebaseUser;//usuario que vai estar logado no momento, se tiver usuario vai ter o id do usuário

 Map<String, dynamic> userData = Map();//dados mais importantes do usuário, e-mail, nome e endreço do usuário.

 bool isLoading = false;//verificar se está modificando ou não

  //realiza o login do usuario -- @required coloca o parâmetro da função como obrigatorio, o {} coloca como opcional, mas quando coloca o required será obrigatorio o preenchimento
  void signUp ({@required Map<String, dynamic> userData, @required String pass, @required VoidCallback onSuccess, @required VoidCallback onFail}){ //recebe a data, senha, se o login foi feito com sucesso ou se teve falha
    isLoading = true; //estamos carregando
    notifyListeners();//notifica o usuário que estamos carregando
    
     _auth.createUserWithEmailAndPassword(//tentando criar o usuário
        email: userData['email'], //recebe o e-mail do firebase
        password: pass//recebe a senha do parâmetro da função
    ).then((user) async {//se for um sucesso vai chamar essa função passando o usuário
      firebaseUser = user;

      await _saveUserData(userData); //esperando para salvar os dados no firebase

      onSuccess();//se funcionar chama a função que mostra sucesso
      isLoading = false;
      notifyListeners();

    }).catchError((e){ //se der erro vai chamar essa função passando o erro
      onFail();//se der erro chama a função onde apresenta a falha
      isLoading = false;
      notifyListeners();
    });
    
  }

  //cadastro do usuário
  void signIn() async{
    isLoading = true;//indica que estou modificando
    notifyListeners();//notifica o usuário de que foi atualizado os dados no app

    await Future.delayed(Duration(seconds: 3));

    isLoading = false;//indica que já terminei de modificar
    notifyListeners();//notifica o usuário de que foi atualizado os dados no app

  }

  //função que verifica se tem usuário logado, então se o usuáiro atual for diferente de null vai retornar true, indicando que tem usuaário logado
  bool isLoggedIn(){
    return firebaseUser != null;
  }

  //recupera a senha
  void recoverPass(){

  }

  //função que sai do usuário
  void signOut() async{
    await _auth.signOut(); //desconecta do usuário
    userData = Map();//reseta o mapa do usúairo
    firebaseUser = null;//reseta o usuário
    notifyListeners();//notifica os usuários
  }

  //usar o _ na função pois essa função chamada somente nessa classe, as outras serão chamadas de outros lugar do código
  Future<Null> _saveUserData (Map<String, dynamic> userData) async {//função que salvará os dados do usuário
    this.userData = userData;
    await Firestore.instance.collection('users').document(firebaseUser.uid).setData(userData);//salva os dados no firebase
  }
}