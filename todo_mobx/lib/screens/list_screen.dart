import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:todomobx/stores/list_store.dart';
import 'package:todomobx/stores/login_store.dart';
import 'package:todomobx/widgets/custom_icon_button.dart';
import 'package:todomobx/widgets/custom_text_field.dart';

import 'login_screen.dart';

class ListScreen extends StatefulWidget {

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  
  final ListStore listStore = ListStore();

  final TextEditingController controller = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          margin: const EdgeInsets.fromLTRB(32, 0, 32, 32),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Tarefas',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 32
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.exit_to_app),
                      color: Colors.white,
                      onPressed: (){
                        Provider.of<LoginStore>(context, listen: false).logout();//faz o logout, listen = false para não ficar obtendo um valor sempre que tiver uma atualização no provider
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context)=>LoginScreen())//vai para a tela de login
                        );
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 16,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: <Widget>[
                       Observer(
                         builder: (_){
                           return  CustomTextField(
                             controller: controller,
                             hint: 'Tarefa',
                             onChanged: listStore.setNewTodoListTitle,//vai acionar a action no list_store que vai alterar o observable
                             suffix: listStore.isFormValid ? CustomIconButton(//só aparece o botão adicionar se estiver preenchido o campo
                               radius: 32,
                               iconData: Icons.add,
                               onTap: (){
                                 listStore.addTodo();//chama a action para adicionar o todoo
                                 controller.clear();//apaga o texto digitado
                               }
                             ) : null,
                           );
                         },
                       ),
                        const SizedBox(height: 8,),
                        Expanded(
                          child: Observer(
                            builder: (_){
                              return  ListView.separated(
                                itemCount: listStore.toDoList.length,//pega o tamanho da lista do listStore
                                itemBuilder: (_, index){
                                  final todo = listStore.toDoList[index];
                                  return Observer(
                                    builder: (_){
                                      return ListTile(
                                        title: Text(
                                          todo.title,//pega o conteúdo da lista do listStore
                                          style: TextStyle(
                                            decoration: todo.done ? TextDecoration.lineThrough : null, //se estiver concluído coloca como sublinhado,
                                            color: todo.done ? Colors.grey : Colors.black//se estiver concluído coloca como cinza senão como preto
                                          ),
                                        ),
                                        onTap: todo.toggleDone,//ao tocar na tarefa vai colocar como concluída
                                      );
                                    },
                                  );
                                },
                                separatorBuilder: (_, __){
                                  return Divider();
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}