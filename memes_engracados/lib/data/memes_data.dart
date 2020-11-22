import 'package:cloud_firestore/cloud_firestore.dart';

class MemesData{

  String category;
  String imgUrl;

  MemesData.fromDocument(DocumentSnapshot snapshot){
    category = snapshot.data()['category'];
    imgUrl = snapshot.data()['imgUrl'];
  }



}