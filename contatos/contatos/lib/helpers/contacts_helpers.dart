import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String contactTable = "contactTable";
final String idColunn = "idColunn";
final String nameColunn = "nameColunn";
final String emailColunn = "emailColunn";
final String phoneColunn = "phoneColunn";
final String imgColunn = "imgColunn";

class ContactHelper {
  //declara a classe e intancia um objeto dela mesmo

  static final ContactHelper _instance = ContactHelper
      .internal(); //static variavel da classe, final variavel não altera

  factory ContactHelper() => _instance;

  ContactHelper.internal();

  Database _db; //_db para não permitir que nenhum outro local no código use o banco

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'contactsnew.db');

    return await openDatabase(
        path, version: 1, onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $contactTable($idColunn INTEGER PRIMARY KEY, $nameColunn TEXT, $emailColunn TEXT, $phoneColunn TEXT, $imgColunn TEXT)"
      );
    });
  }

  Future<Contact> saveContact(Contact contact) async {
    //assicrona e no futuro pois não ocorre no mesmo tempo
    Database dbContact = await db; //obtém o banco de dados
    contact.id = await dbContact.insert(contactTable,
        contact.toMap()); // insere o contato no banco e obtem no id do contato
    return contact; //retorna o contato
  }

  Future<Contact> getContact(int id) async {
    //função que busca o contato
    Database dbContact = await db; //obtém o banco de dados
    List<Map> maps = await dbContact.query(contactTable,
        //retorna a lista de contato através uma query de consulta no banco
        columns: [idColunn, nameColunn, emailColunn, phoneColunn, imgColunn],
        where: "$idColunn = ?",
        whereArgs: [id]);
    if (maps.length > 0) { //se a lista for maior do que zero
      return Contact.fromMap(maps.first); //pega o primeiro contato
    } else {
      return null;
    }
  }

  Future<int> deleteContact (int id) async{//função que delet o contato
    Database dbContact = await db; //obtém o banco de dados
    return await dbContact.delete(contactTable, where: "$idColunn = ?", whereArgs: [id]);//usa o id do contato, pois na função chamou o id
  }

  Future<int> updateContact (Contact contact) async{//função que atualiza um contato
    Database dbContact = await db; //obtém o banco de dados
    return await dbContact.update(contactTable, contact.toMap(), where: "$idColunn = ?", whereArgs: [contact.id]);//usa o id do contato pois na funçao chamou o contact
  }

  Future<List> getAllContacts () async{//função que retorna toda a lista de contatos
    Database dbContact = await db; //obtém o banco de dados
    List listMap = await dbContact.rawQuery("SELECT * FROM $contactTable");//consulta os contatos e guarda a lista
    List<Contact> listContact = List();//declara a lista que receberá os contatos
    for(Map m in listMap){
      listContact.add(Contact.fromMap(m));
    }
    return listContact;
  }

  Future<int> getNumber() async{//função que retorna o número de contatos
    Database dbContact = await db; //obtém o banco de dados
    return Sqflite.firstIntValue(await dbContact.rawQuery("SELECT COUNT (*) FROM $contactTable"));//consulta o banco para retornar a quantidade de contatos na tabela
  }

  Future close() async{//função que desconecta do banco
    Database dbContact = await db; //obtém o banco de dados
    dbContact.close();//desconecta do banco
  }

}
  class Contact{

  int id;
  String name;
  String email;
  String phone;
  String img;

  Contact();

  Contact.fromMap(Map map){
  id = map[idColunn];
  name = map[nameColunn];
  email = map[emailColunn];
  phone = map[phoneColunn];
  img = map[imgColunn];
  }

  Map toMap(){
  Map<String, dynamic> map = {
  nameColunn: name,
  emailColunn: email,
  phoneColunn: phone,
  imgColunn: img
  };
  if(id != null){//id não retorna o mapa do app, pois é o banco de dados que atrbui o ID
    map[idColunn] = id;
  }
    return map;
  }

  @override//basta dar um print contact que ele mostrará todos os dados do contato.
  String toString() {
  return 'Contact(id: $id, name: $name, email: $email, phone: $phone, image: $img';
  }
}
