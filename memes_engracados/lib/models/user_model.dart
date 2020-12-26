import 'package:flutter/rendering.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class UserModel extends Model{

   FirebaseAuth _auth = FirebaseAuth.instance;
   
   FirebaseAuth firebaseUser;

    Map<String, dynamic> userData = Map();

    bool isLoading = false;

    static UserModel of(BuildContext context) =>
        ScopedModel.of<UserModel>(context);

    @override    
    void addListener(VoidCallback listener){
      super.addListener(listener);
    }

    void signUp ({@required Map<String, dynamic> userData, @required String pass, @required VoidCallback onSuccess, @required VoidCallback onFail}){ //recebe a data, senha, se o login foi feito com sucesso ou se teve falha
    
    isLoading = true; 

    notifyListeners();
    
     _auth.createUserWithEmailAndPassword(
        email: userData['email'], 
        password: pass
    ).then((user) async {
      firebaseUser = user as FirebaseAuth;

      await _saveUserData(userData); 

      onSuccess();
      isLoading = false;
      notifyListeners();

    }).catchError((e){ 
      onFail();

      isLoading = false;

      notifyListeners();
    });
    
  }

  void signIn({@required String email, @required String pass, @required VoidCallback onSuccess, @required VoidCallback onFail}) async{
    isLoading = true;

    notifyListeners();
    

    _auth.signInWithEmailAndPassword(
        email: email, 
        password: pass
    ).then((user) async {
      firebaseUser = user as FirebaseAuth;

      await _loadCurrentUser(); 

          onSuccess();
          isLoading = false;
          notifyListeners();

        }).catchError((e){
          onFail();

          isLoading = false;

          notifyListeners();

    });
  }
  //função que verifica se tem usuário logado, então se o usuáiro atual for diferente de null vai retornar true, indicando que tem usuaário logado
  bool isLoggedIn(){
    return firebaseUser != null;
  }

  //função que recupera a senha
  void recoverPass(String email) async {
    _auth.sendPasswordResetEmail(email: email);
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
    await FirebaseFirestore.instance.collection('users').doc(firebaseUser.currentUser.uid).set(userData);//salva os dados no firebase
  }

  Future<Null> _loadCurrentUser() async{//função que carrega os dados do usuário do firebase
    if(firebaseUser == null)//se não tiver usuário logado, tenta recuperar o usuário
      firebaseUser = _auth.currentUser as FirebaseAuth;
    if(firebaseUser != null){//se tem usuário logado, mostra o usuário
      if(userData['name'] == null){
        DocumentSnapshot docUser = await FirebaseFirestore.instance.collection('users').doc(firebaseUser.currentUser.uid).get();//carega do firestore o usuário
        userData = docUser.data();//guarda o que retornou no userData
      }
    }
    notifyListeners();
    }
}
