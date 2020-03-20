import 'dart:io';
import 'package:contatos/helpers/contacts_helpers.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'contact_page.dart';

enum OrderOptions{orderaz, orderza}//cria a variavel que vai ordenar de a-z e z-a

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper =
      ContactHelper(); //um objeto contacthelper e um banco de dados

  List<Contact> contacts = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contatos'),
        backgroundColor: Colors.red,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<OrderOptions>(//cria o botão de 3 pontinhos com opções de ordenar
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
                const PopupMenuItem<OrderOptions>(//cria a opção de ordenar de A-Z e guarda o valor na variavel
                  child: Text("Ordenar de A-Z"),
                  value: OrderOptions.orderaz,
                ),
                const PopupMenuItem<OrderOptions>(//cria a opção de ordenar de Z-A e guarda o valor na variavel
                  child: Text("Ordenar de Z-A"),//
                  value: OrderOptions.orderza,
              ),
            ],
            onSelected: _orderList,//chama a função quando clicar no botão de 3 pontinhos
          )
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        //cria um botão flutuante que adiona um novo contato
        onPressed: () {
          _showContactPage();
        },
        child: Icon(Icons.add), //icone de adicionar
        backgroundColor: Colors.red, //cor do icone
      ),
      body: ListView.builder(
          //lista que irá mostrar todos os contatos
          padding: EdgeInsets.all(10.0),
          itemCount: contacts
              .length, //busca o tamanho da lista, que é a lista de contatos
          itemBuilder: (context, index) {
            return _ContactCard(context,
                index); //chama a função e passa parâmetro context e index para buscar o item na lista
          }),
    );
  }

  Widget _ContactCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            //cria a uma linha que terá a imagem e uma coluna com os textos
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: contacts[index].img != null
                            ? // se for diferente de nulo pego a imagem dele
                            FileImage(File(contacts[index].img))
                            : AssetImage(
                                "images/pessoa.png"))), //se for nulo pega uma imagem padrão que fica no pubspec.yaml
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment
                      .start, //coloca centralizado no inicio da coluna
                  children: <Widget>[
                    Text(
                      contacts[index].name ??
                          "", // se não tiver nada saldo mostra nada nada
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      contacts[index].email ??
                          "", // se não tiver nada saldo mostra nada nada
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      contacts[index].phone ??
                          "", // se não tiver nada saldo mostra nada nada
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        _showOptions(context, index);
      },
    );
  }

  void _showOptions(BuildContext context, int index){
    showModalBottomSheet(//widget que ao clicar em cima do contato abre uma caixa com botões de editar, excluir e ligar.
        context: context,
        builder: (context){
          return BottomSheet(
            onClosing: (){},//precisa dele para o widget bottomsheet
            builder: (context){
              return Container(//container que vai ter 3 botões dentro da coluna
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,//usar o mínimo de espaço na tela
                  children: <Widget>[
                    Padding(//para que seja possível separar os botões e eles não fiquem grudados
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(//botão ligar
                        child: Text("Ligar",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: (){
                          launch("tel:${contacts[index].phone}");//chama o telefone do celular para ligar para o conato
                          Navigator.pop(context);//volta a tela
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(//botão editar
                        child: Text("Editar",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: (){
                          Navigator.pop(context);//para fechar a janelinha dos botões e vai para a próxima tela
                          _showContactPage(contact: contacts[index]); //usuário clicar em cima do contato vai abrir o próprio contato para edição\visualização
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(//botão exluir
                        child: Text("Exluir",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),//estilo do texto exluir
                        ),
                        onPressed: (){
                           helper.deleteContact(contacts[index].id);//pega o id do contato para excluir
                           setState(() {
                             contacts.removeAt(index);//remove o contato da tela e atualiza com o setstate
                             Navigator.pop(context);//fecha a janelinha com os botões ligar, excluir e editar
                           });
                        },
                      ),
                    )
                  ],
                ),
              );
            },
          );
        });
  }

  void _showContactPage({Contact contact}) async {
    //Contact entre chaves pois pode ou não ser pasasdo parâmetro
    final recContact = await Navigator.push(//retorna o dado que a tela de contato nos enviar, só depois que retorna os dados, está recebendo um contato da tela contactpage
        context,
        MaterialPageRoute(
            builder: (context) => ContactPage(
                  contact: contact,
                ))); //cria uma rota para a página de Contato ou vai criar um novo contato ou vai editar o contato que clicar.
    if (recContact != null) {//verifica se o contato recebido da tela é diferente de nulo, se não fez alteração não vai retornar nada, se receber algum contato tem que saber se é um contato novo ou um conato que enviou
      if (contact != null) {//enviou um contato, estamos editando um contato
        await helper.updateContact(recContact);//atualiza o contato
      } else {
        await helper.saveContact(recContact);//salva um novo contato
      }
      _getAllContacts();//depios que atualizou ou incluiu o contato, retorna todos os contatos , retorna a lista para que possamos ver o novo contato
    }
  }

  void _getAllContacts() {//função que retorna todos os contatos da lista
    helper.getAllContacts().then((list) {
        setState(() {
          contacts = list;
        });
      },
    );
  }

  void _orderList(OrderOptions result){
    switch(result){
      case OrderOptions.orderaz:
        contacts.sort((a, b){//sort ordena e passa uma função que ordena a e b
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());//tolowercase para converter para minuúsculo e compareTo para comparar o nome de a com o nome de b
        });
    break;
      case OrderOptions.orderza:
        contacts.sort((a, b){//sort ordena e passa uma função que ordena a e b
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());//tolowercase para converter para minuúsculo e compareTo para comparar o nome de a com o nome de b
        });
    break;
    }
    setState(() {
      //setstate vazio para atualizar a página
    });
  }
}