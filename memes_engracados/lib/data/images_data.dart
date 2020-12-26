import 'package:cloud_firestore/cloud_firestore.dart';

class ImagesData{

  String category;
  String id;
  String imgUrl;
  ImagesData imagesData;

  ImagesData.fromDocument(DocumentSnapshot snapshot){
    category = snapshot.data()['categoryId'];
    id = snapshot.data()['imageId'];
    imgUrl = snapshot.data()['imgUrl'];
  }

  Map<String, dynamic> toMap(){//armazena os dados da imagem no banco de dados
    return {
      'category': category,
      'ImageId': id,
      'ImagUrl': imgUrl,
      'imagesData': imagesData,
    };
  }
}