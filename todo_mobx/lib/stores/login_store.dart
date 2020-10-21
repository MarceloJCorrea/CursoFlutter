import 'package:mobx/mobx.dart';

part 'login_store.g.dart';

class LoginStore = _LoginStore with _$LoginStore;

abstract class _LoginStore with Store {

  _LoginStore(){
    autorun((_){//reação que é chamada sempre que um observable tem um dado lido ou modificado

    });
  }

  @observable
  String email = '';

  @action
  void setEmail (String value) => email = value; //vai receber o novo e-mail e setar esse valor no mail

  @observable
  String password = '';

  @action
  void setPassword (String value) => password = value;

  @computed
  bool get isEmailValid => email.length > 6;

  @computed
  bool get isPasswordValid => password.length > 6; //valida se a senha é maior que 6

  @computed
  bool get isFormValid => isEmailValid && isPasswordValid;//vai validar se o email e a senha são válidos

  @observable
  bool passwordVisible = false;

  @action
  void togglePasswordVisibility () => passwordVisible = !passwordVisible;//muda de false pra true e de true pra false pra mostrar ou não a senha

  @observable
  bool loading = false;

  @action
  Future<void> login() async{
    loading = true;

    await Future.delayed(Duration(seconds: 2));

    loading = false;
    loggedIn = true;

    email = '';
    password = '';

  }

  @computed
  Function get loginPressed =>
      (isEmailValid && isPasswordValid && !loading) ? login : null; //se o email e senha é válido e não está carregadno vai entrar na função de login, senão bloqueia o botão

  @observable
  bool loggedIn = false;

  @action
  void logout(){//desconecta o login do usuário
    loggedIn = false;
  }

}