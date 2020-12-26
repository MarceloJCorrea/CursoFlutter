import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memesengracados/data/images_data.dart';
import 'package:memesengracados/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class ImagesModel extends Model{

  List<ImagesData> images = [];

  UserModel user;

  ImagesModel(this.user){
    if(user.isLoggedIn())
      loadImages();
  }

  bool isLoading = false;

  void loadImages() async {
    QuerySnapshot query = await FirebaseFirestore.instance.collection('users').doc(
        user.firebaseUser.currentUser.uid).collection('images').get();

    images = query.docs.map((doc) => ImagesData.fromDocument(doc))
        .toList(); //transformando cada documento que retornou do firebase em um ImagesData, depois retorno uma lista com todos os ImagesData na lista de imagens

    notifyListeners();
  }

  void addImageFavorite(ImagesData imagesData){//adciona a imagem como favorito no usuário
    images.add(imagesData);

    FirebaseFirestore.instance.collection('users').doc(user.firebaseUser.currentUser.uid)//pega o id do usuário no Firestore
        .collection('images').add(imagesData.toMap()).then((doc){//entra na coleção images e adiciona num mapa, que já tem função "toMap" criada no imagesData
       imagesData.id = doc.id;//armazena o id da imagem no ImagesData para ser possível remover depois
    });
    notifyListeners();//notifica os listeners, porque acabou de adicionar uma nova imagem e quer que liste essa nova imagem
  }

  void removeImageFavorite(ImagesData imagesData){//remove imagem do favorito do usuário
    FirebaseFirestore.instance.collection('users').doc(user.firebaseUser.currentUser.uid).
       collection('images').doc(imagesData.id).delete();//delete o documento de um imageData dentro da coleção 'users'

    images.remove(imagesData);//remove a imagem da lista de imagens do usuário

    notifyListeners();

  }

}