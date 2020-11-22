import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData{//declaração da classe com as suas variáveis\atributos

  String category;
  String id;
  String title;
  String description;
  double price;
  List images;
  List sizes;

  ProductData.fromDocument(DocumentSnapshot snapshot){//declara o construtor e passa o que recebe do firestore para as variáves da classe
    id = snapshot.id;
    title = snapshot.data()["title"];
    description = snapshot.data()["description"];
    price = snapshot.data()["price"] + 0.0;// + 0.0 resolve o problema do firestore colocar o preço como int e a classe como double, isso irá forçar sempre ser double o resultado do firestore
    images = snapshot.data()["images"];
    sizes = snapshot.data()["sizes"];

  }

  Map<String, dynamic> toResumedMap(){//irá armazenar os dados somente de um resumo do produto
    return{
      'title': title,
      'description': description,
      'price': price,
    };
  }
}