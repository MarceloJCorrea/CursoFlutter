import 'package:mobx/mobx.dart';

part 'todo_store.g.dart';

class ToDoStore = _ToDoStore with _$ToDoStore;

abstract class _ToDoStore with Store {

  _ToDoStore(this.title);

  final String title;

  @observable
  bool done = false;//inicia a tarefa como não concluída

  @action
  void toggleDone() => done = !done;//se true ao tocar vai ficar false e vice versa

}