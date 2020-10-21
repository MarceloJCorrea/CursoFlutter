import 'package:mobx/mobx.dart';
import 'package:xlomobx/models/user.dart';
import 'package:xlomobx/repositories/user_repository.dart';

part 'user_manager_store.g.dart';

class UserManagerStore = _UserManagerStore with _$UserManagerStore;

abstract class _UserManagerStore with Store {

  _UserManagerStore(){
    _getCurrentUser();//construtor que chama a função para verificar
  }

  @observable
  User user;

  @action
  void setUser(User value) => user = value;

  @computed
  bool get isLoggedIn => user != null;//se user for diferente de nulo quer dizer que o usuário está logado

  Future<void> _getCurrentUser() async {//recupera o usuário
    final user = await UserRepository().currentUser();//chama a função lá no responsitório.
    setUser(user);//se tiver o usuário logado dá o set User com o usuário, senão estiver logado dá o setUser como null
  }

}