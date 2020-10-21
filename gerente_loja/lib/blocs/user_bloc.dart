import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserBloc extends BlocBase{//exntende o bloc

  final _usersController = BehaviorSubject<List>();//chama o rxdart, do tipo list, por conta do outUsers abaixo

  Stream<List> get outUsers => _usersController.stream; //não retorna um map retorna uma lista

  Map<String, Map<String, dynamic>> _users = {}; //pega o uid e os dados do usuário no mapa

  Firestore _firestore = Firestore.instance; //variavel que instancia o firebase

  UserBloc(){//sempre que adicionar, remover ou movidificar o usuário será chamado o usuário
    _addUsersListener();
  }

  void onChangedSearch(String search){//função do campo de busca
    if(search.trim().isEmpty){//tim remove os espaços
      _usersController.add(_users.values.toList()); //se for vazio a pesquisa retorna a lista de clientes
    } else{
      _usersController.add(_filter(search.trim())); //se tiver pesquisado passa a pesquisa para a funçaão _filter realizar a busca
    }
  }

  List<Map<String, dynamic>> _filter(String search){//função que fará o filtro no campo de pesquisa da tela por clientes
    List<Map<String, dynamic>> filteredUsers = List.from(_users.values.toList()); //copiou a lista de usuário e coloquei no filteredUsers
    filteredUsers.retainWhere((user){//função recebe os dados do usuáiro que vai ser o Map
      return user['name'].toUpperCase().contains(search.toUpperCase());// se a pesquisa está constida no nome do cliente, mantém o cliente na pesquisa, caso contrário este cliente será removido do filtro da pesquisa.
    });
    return filteredUsers;
  }

  void _addUsersListener(){
    _firestore.collection('users').snapshots().listen((snapshot) { //obtem as modificações do firebase
      snapshot.documentChanges.forEach((change){ //pega as mudanças do documento
        String uid = change.document.documentID;//id do usuário cujo os dados foram modificados

        switch(change.type){//pega o tipo da mudança
          case DocumentChangeType.added:
            _users[uid] = change.document.data;//armazenando os dados do usuário no mapa
            _subscribeToOrders(uid);//adiciona o usuário
            break;
          case DocumentChangeType.modified:
            _users[uid].addAll(change.document.data);//coloca as modificações no mapa de usuários
            _usersController.add(_users.values.toList());
            break;
          case DocumentChangeType.removed:
            _users.remove(uid);//remove o usuário do mapa
            _unsubscriptionToOrders(uid);//remove o usuário
            _usersController.add(_users.values.toList());//além de remover, coloca no controlador para remover da tela
            break;
        }
      });
    });
  }

  void _subscribeToOrders(String uid){//_users[uid]['subscription'] armazena os dados no subscription para chamar e cancelar depois
    _users[uid]['subscription'] = _firestore.collection('users').document(uid).collection('orders').snapshots().listen((orders) async { //estou acessando a lista de pedidos que está dentro da coleção users\orders

      int numOrders = orders.documents.length; //numero de pedidos

      double money = 0.0;

      for (DocumentSnapshot d in orders.documents){//para cada documento pega o uid do pedido e obtem os dados do pedido
        DocumentSnapshot order = await _firestore.collection('orders').document(d.documentID).get();

        if(order.data == null) continue;//ignora a parte de baixo e vai para o próximo item do for, isso para verificar se o pedido existe e não apresentar erro
        money += order.data['totalPrice'];//pega a quantidade de dinheiro que o cliente gastou

      }

      _users[uid].addAll(//salvar os dados nos usuários, adiciona essas duas outras informações aos dados locais do usuário
        {'money': money, 'orders': numOrders}//mapa entre chaves
      );

      _usersController.add(_users.values.toList());//pegar apenas os valores do mapa, coloca os dados do usuário no UsersController, assim todos os lugares que observa o controle vai modificar a lista

    });
  }

  Map<String, dynamic> getUser(String uid){//retorna os dados do usuário
    return _users[uid];
  }

  void _unsubscriptionToOrders(String uid){
    _users[uid]['subscription'].cancel();//cancela o subscritipons do _users que recebeu os dados acima
  }

 @override
  void dispose() {
    _usersController.close();//fecha a variável
  }
}