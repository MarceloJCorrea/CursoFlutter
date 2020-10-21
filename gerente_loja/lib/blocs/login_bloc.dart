import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gerenteloja/validator/login_validators.dart';
import 'package:rxdart/rxdart.dart';

enum LoginState {IDLE, LOADING, SUCESS, FAIL}//idle não está fazendo nada, loading está processando, sucess deu certo o login, fail falou o login

class LoginBloc extends BlocBase with LoginValidators{//with para poder usar o email e senha do validator

  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _stateController = BehaviorSubject<LoginState>();//stream do tipo LoginState que é um ENUM.

  Stream<String> get outEmail => _emailController.stream.transform(validateEmail);//saída do e-mail já transformada no dado validado na classe loginValidators
  Stream<String> get outPassword => _passwordController.stream.transform(validaPassword);//saída da senha já transformada no dado validado na classe loginValidators
  Stream<LoginState> get outState => _stateController.stream;

  Stream<bool> get onSubmitValid => Observable.combineLatest2(//caso a combinação dos dois streams seja válida, vai retornar true
      outEmail, outPassword, (a, b) => true
  );

  Function(String) get changeEmail => _emailController.sink.add;//o que mandar para essa função vai mandar automaticamente para o _emailConttoller.sink.add
  Function(String) get changePassword => _passwordController.sink.add;

  StreamSubscription _streamSubscription;//para o loginBloc não ficar rodando durante o app executar

  LoginBloc(){//construtor do loginBloc, strreamSubscription = para que ele não rode o temp toodo

    FirebaseAuth.instance.signOut();
    _streamSubscription = FirebaseAuth.instance.onAuthStateChanged.listen((user) async { //se abrir o app e o usuário estiver logado nem vai mostrar a tela de login
      if(user != null){
        if(await verifyPrivileges(user)){//verifica se o usuário que está logado ou tentando logar tem privilégio de adm
        _stateController.add(LoginState.SUCESS);//fala para a tela que deu certo
      } else {
          FirebaseAuth.instance
              .signOut(); //desconecta do usuário caso o usuário que já está logado no app, abra o aplicativo e não tena privilégio
          _stateController.add(LoginState.FAIL); //fala pra tela que de errado
        }
      } else {
        _stateController.add(LoginState
            .IDLE); //tela não vai fazer nada, nem mostrar falha do login
        }
    });
  }

  void submit(){
    final email = _emailController.value;
    final password = _passwordController.value;

    _stateController.add(LoginState.LOADING);//estou falando que estou carregando

    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
    ).catchError((e){
      _stateController.add(LoginState.FAIL);//aviso para a tela que deu cerro
    }
    );
  }

  //future bool para que os returns retorne para a função e não somente dentro da função anônima de baixo
  Future<bool> verifyPrivileges(FirebaseUser user) async{//verifica no firebase se o usuário faz parte faz parte do grupo admin
    return await Firestore.instance.collection('admin').document(user.uid).get().then((doc){
      if(doc.data != null){//documento existe e retorno true, caso contrário retorna false
        return true;
      } else {
        return false;
      }
    }).catchError((e){
      return false;
    });
  }

  @override
  void dispose() {
    _emailController.close(); //fecha a variavel do emailController
    _passwordController.close();//fecha a variavel do passwordController
    _stateController.close();
    _streamSubscription.cancel();//fecha o stream subscritpiotn
  }


}