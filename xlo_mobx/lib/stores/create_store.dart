import 'package:mobx/mobx.dart';

part 'create_store.g.dart';

class CreateStore = _CreateStore with _$CreateStore;

abstract class _CreateStore with Store {

  ObservableList images = ObservableList();//sempre que adicionar uma imagem vai atualizar os balõeszinhos com as imagens

}