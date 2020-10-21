import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:xlomobx/helpers/extensions.dart';
import 'package:xlomobx/models/user.dart';
import 'package:xlomobx/repositories/user_repository.dart';
import 'package:xlomobx/stores/user_manager_store.dart';

part 'signup_store.g.dart';

class SignupStore = _SignupStore with _$SignupStore;

abstract class _SignupStore with Store {

  @observable
  String name;

  @action
  void setName(String value) => name = value;

  //valida se o nome tem mais de 6 caracteres e se não é nulo
  @computed
  bool get nameValid => name != null && name.length > 6;
  String get nameError {
    if(name == null || nameValid) {//não mostra erro se o email tem mais de 6 caracteres ou se nem foi digitado o campo ainda
      return null;
    } else if(name != null && name.isEmpty) {//mostra erro se não preencheu o campo ou se preencheu e apagou
      return 'Campo obrigatório';
    } else {
      return "Nome muito curto";//mostra o erro se não tiver mais de 6 caracteres
    }
  }

  @observable
  String email;

  @action
  void setEmail(String value) => email = value;

  @computed
  bool get emailValid => email != null;/* && email.isEmailValid();*///valida o email através da classe extensions que manipula Strings
  String get emailError{
    if(email == null || emailValid){
      return null;
    }else if (email.isEmpty){
      return 'Campo obrigatório';
    }else{
      return 'E-mail inválido';
    }
  }

  @observable
  String phone;

  @action
  void setPhone(String value) => phone = value;

  @computed
  bool get phoneValid => phone != null && phone.length >= 14;//valida o telefone se tem mais de 14 dígitos
  String get phoneError{
    if(phone == null || phoneValid){
      return null;
    }else if (phone.isEmpty){
      return 'Campo obrigatório';
    }else{
      return 'Telefone inválido';
    }
  }

  @observable
  String pass1;

  @action
  void setPass1(String value) => pass1 = value;

  //valida se a senha tem mais de 6 caracteres e se não é nulo
  @computed
  bool get pass1Valid => pass1 != null && pass1.length > 6;
  String get pass1Error {
    if(pass1 == null || pass1Valid) {//não mostra erro se o email tem mais de 6 caracteres ou se nem foi digitado o campo ainda
      return null;
    } else if(pass1 != null && pass1.isEmpty) {//mostra erro se não preencheu o campo ou se preencheu e apagou
      return 'Campo obrigatório';
    } else {
      return "Nome muito curto";//mostra o erro se não tiver mais de 6 caracteres
    }
  }

  @observable
  String pass2;

  @action
  void setPass2(String value) => pass2 = value;

  //valida se a senha 2 concide com a senha 1
  @computed
  bool get pass2Valid => pass2 != null && pass2 == pass1;
  String get pass2Error {
    if(pass2 == null || pass2Valid)
      return null;
    else
      return 'Senhas não coincidem';
  }

  @computed
  bool get isFormValid => nameValid && emailValid && phoneValid && pass1Valid && pass2Valid;//verifia se os formulários são válidos para habilitar o botão

  @observable
  bool loading = false;

  @observable
  String error;

  @action
  Future<void> _signUp() async{
    loading = true;//estou carregando

    final user = User(//armazena no user os dados da classe User para fazer o login
      name: name,
      email: email,
      phone: phone,
      password: pass1
    );

    try {//caso dê certo
      final resultUser = await UserRepository().signUp(user);//passa o user para o repositoy para fazer o login do usuário
      GetIt.I<UserManagerStore>().setUser(resultUser);//armazena o resultUser no get IT para ser usado em qualquer lugar no app
    } catch(e){
      error = e;//caso dê erro vai passar o erro para exibir na tela
    }

    loading = false; //terminei de carregar
  }

  //isFormalid && !loading) habita o botão se estiver carregando
  @computed
  Function get signUpPressed => (isFormValid && !loading) ? _signUp : null;//vai deixar o botão cadastrar ativo somente se todos os campos estiverem validados

}