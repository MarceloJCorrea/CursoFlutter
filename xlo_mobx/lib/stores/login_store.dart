import 'dart:core';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:xlomobx/repositories/user_repository.dart';
import 'package:xlomobx/stores/user_manager_store.dart';

part 'login_store.g.dart';

class LoginStore = _LoginStore with _$LoginStore;

abstract class _LoginStore with Store {

  @observable
  String email;

  @action
  void setEmail(String value) => email = value;

  @computed
  bool get emailValid => email != null;
  String get emailError =>
      email == null || emailValid ? null : 'Email inválido';

  @observable
  String password;

  @action
  void setPassword(String value) => password = value;

  @computed
  bool get passwordValid => password != null && password.length > 4;
  String get passwordError =>
      password == null || passwordValid ? null : "Senha inválida";

  @computed
  bool get isFormValid => emailValid && passwordValid;

  @observable
  bool loading = false;

  @observable
  String error;

  @action
  Future<void> _login() async{
    loading = true;

    try {
      final user = await UserRepository().loginWithEmail(email, password);//passa o email e a senha para fazer o login dno parse
      GetIt.I<UserManagerStore>().setUser(user);//armazena o user no get IT para ser usado em qualquer lugar no app
    } catch (e){
      error = e;//caso ocorra o erro vai armazenr o erro e apresentat

    }
    loading = false;

  }

  @computed
  Function get loginPressed => (isFormValid & !loading) ? _login : null;


}