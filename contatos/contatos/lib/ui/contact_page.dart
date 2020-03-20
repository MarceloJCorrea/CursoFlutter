import 'dart:io';

import 'package:contatos/helpers/contacts_helpers.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {

 final Contact contact;//declarou o contato na página

  ContactPage ({this.contact});//declara um construtor o {} coloca o parametro como opcional

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _nameFocus = FocusNode() ; // criando um foco para o campo de nome

  bool _userEdited = false;

  Contact _editContact;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.contact == null){ //widget.contat para buscar a variavel do contato que está fora da classe
      _editContact = Contact();//se o contato for nulo irá criar um novo contato
    }else {
      _editContact = Contact.fromMap(widget.contact.toMap());//tranforma o contato em uma mapa e pega esse contato através do mapa, basicamente duplica o contato e coloca no editContat
    }

    //quando iniciar a tela eu quero que mostra os dados de nome, email e telefone na tela se etiver alterando.
    _nameController.text = _editContact.name;
    _emailController.text = _editContact.email;
    _phoneController.text = _editContact.phone;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope( //chamar uma função minha antes de clicar no sair da tela
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(_editContact.name ?? "Novo Contato"),//texto do app bar, se não tem nome o contato, irá aparecer "Novo Contato", se tiver nome vai apararer o nome do contato
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(//botão flutuante que salva
          onPressed: (){
            if (_editContact.name != null && _editContact.name.isNotEmpty){//nome não vazio e diferente de nulo
              Navigator.pop(context, _editContact);
            }else{//colocar o campo no foco de outro campo para mostrar que ele não está vazio
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
          backgroundColor: Colors.red,
          child: Icon(Icons.save),
        ),
        body: SingleChildScrollView(//para não cortar a página usa esse widget
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                GestureDetector(//para ser capaz de clicar na imagem usa esse widget
                  child: Container(
                    width: 80.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: _editContact.img != null
                                ? // se for diferente de nulo pego a imagem dele
                            FileImage(File(_editContact.img))
                                : AssetImage("images/pessoa.png"))),//se for nulo pega uma imagem padrão que fica no pubspec.yaml
                  ),
                onTap: (){
                    ImagePicker.pickImage(source: ImageSource.camera).then((file){//chama a camera para que o usúario tire foto para o contato
                      if(file == null) return;//se usuário não tira a foto não grava e não retorna nada
                      _editContact.img = file.path;//grava a foto no campo de imagem do contato
                    });
                  },
                ),
                TextField(
                  controller: _nameController,
                  focusNode: _nameFocus,//criando o foco para o campo do nome
                  decoration: InputDecoration(labelText: 'Nome'),
                  onChanged: (text){
                    _userEdited = true;//indica que está sendo alterado o campo nome
                    setState(() {
                      _editContact.name = text;//vai atualizar o nome na na barra do aplicativo
                    });
                  },
                ),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'E-mail'),
                  onChanged: (text){
                    _userEdited = true;//indica que está sendo alterado o campo
                    _editContact.email = text;
                  },
                  keyboardType: TextInputType.emailAddress, //coloca formato de email no campo
                ),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: 'Phone'),
                  onChanged: (text){
                    _userEdited = true;//indica que está sendo alterado o campo
                    _editContact.phone = text;
                  },
                  keyboardType: TextInputType.phone, //coloca formato de telefone no campo
                )
              ],
            )
        ),
      ),
    );
  }
  Future<bool> _requestPop(){
    if(_userEdited){
      showDialog(context: context,
        builder: (context){//força manuamente sair da tela.
          return AlertDialog(//caixa de diálogo da mensagem de aviso
            title: Text("Descartar Alterações"),//texto do aviso
            content: Text("Se sair as alterações serão perdidas."),//informação de aviso
            actions: <Widget>[
              FlatButton(
                child: Text("Cancelar"),
                onPressed: (){
                  Navigator.pop(context);//permance na pagina, só sai da mensagem
                },
              ),
              FlatButton(
                child: Text("Sair"),
                onPressed: (){
                  Navigator.pop(context);//volta a pagina do home
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
      );
      return Future.value(false);//não sai automaticamente a tela
    } else{
      return Future.value(true);//sair automaticamente da tela
    }
  }

}