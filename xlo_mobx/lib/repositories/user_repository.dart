import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:xlomobx/models/user.dart';
import 'package:xlomobx/repositories/parse_erros.dart';
import 'package:xlomobx/repositories/table_keys.dart';

class UserRepository{

  Future<User> signUp(User user) async{//envia algumas informações para o parse, mas o parse já cria o id e a data de criação
    final parseUser = ParseUser(
      user.email, user.password, user.email//chave do usuário vai ser o email
    );

    //pega os key da classe table_keys para armazenar no banco, se precisar mudar o nome da tabela no banco, muda somente no table_keys
    parseUser.set<String>(keyUserName, user.name);
    parseUser.set<String>(keyUserPhone, user.phone);
    parseUser.set(keyUserType, user.type.index);//quando for particular armazena 0 quando for profissional armazena 1

    final response = await parseUser.signUp();//faz o login no parse passando as chaves acima
    
    if(response.success){//se der suscesso, response.result está no formado parseUser, tem que transformar em um objeto User no mapParseToUser
      //return response.result;
      return mapParseToUser(response.result);
    } else {//se der erro
      return Future.error(ParseErrors.getDescription(response.error.code)); //pega o código do error transformei em um texto descritivo e em português e retornei ele como um future error
    }

  }

  User mapParseToUser(ParseUser parseUser){//converte de parse para classe user
    return User(
      id: parseUser.objectId,//id do usuário
      name: parseUser.get(keyUserName),//nome do usuário
      email: parseUser.get(keyUserEmail),//email do usuário
      phone: parseUser.get(keyUserPhone),//telefone do usuáiro
      type: UserType.values[parseUser.get(keyUserType)],//transforma o enumerador em uma lista
      createdAt: parseUser.get(keyUserCreatedAt),
    );
  }

  Future<User> loginWithEmail(String email, String password) async {
    final parseUser = ParseUser(email, password, null);

    final response = await parseUser.login();

    if(response.success){
      return mapParseToUser(response.result);
    } else
      return Future.error(ParseErrors.getDescription(response.error.code)); //pega o código do error transformei em um texto descritivo e em português e retornei ele como um future error
  }

  Future<User> currentUser() async {//recupera o usuário logado
    final parseUser = await ParseUser.currentUser();
    if(parseUser != null){//caso o usuário esteja logado
      final response = await ParseUser.getCurrentUserFromServer(parseUser.sessiontToken);//recupera o token do usuário logado
      if(response.success){//se conseguir recuperar, quer dizer que o usuário está logado ainda, então recupera o mapa do usuário.
        return mapParseToUser(response.result);
      } else {//senão conseguir recuperar quer dizer que a sessão expirou, então faz logout
        await parseUser.logout();
      }
    }
    return null;//caso o usuário não esteja logado retorna null

  }



}