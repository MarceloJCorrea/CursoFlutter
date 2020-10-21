import 'package:mobx/mobx.dart';
import 'package:todomobx/stores/todo_store.dart';

part 'list_store.g.dart';

class ListStore = _ListStore with _$ListStore;

abstract class _ListStore with Store {

  @observable//usardo para observar
  String newTodoList = "";

  @action//usardo para retornar algo pro observale
  void setNewTodoListTitle(String value) => newTodoList = value;

  @computed//usado para validar
  bool get isFormValid => newTodoList.isNotEmpty;

  ObservableList<ToDoStore> toDoList = ObservableList<ToDoStore>();  //observable list observa não apenas a referencia mas as mudanças na lista

  @action
  void addTodo(){//pega o texto digitado e adiona na lista
    toDoList.insert(0, ToDoStore(newTodoList)); //adiciona iniciando no index 0
    newTodoList = "";//força apaga o conteúdo após o usuário já ter adicionado a tarefa
  }

}
