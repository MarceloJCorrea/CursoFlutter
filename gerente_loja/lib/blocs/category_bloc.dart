import 'dart:async';
import 'dart:io';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';

class CategoryBloc extends BlocBase{

  final _titleController = BehaviorSubject<String>();//do tipo string, pois vai ser um texto
  final _imageController = BehaviorSubject();//não especifica o tipo, pois pode ter tanto o texto quanto o file
  final _deleteController = BehaviorSubject<bool>();

  Stream<String> get outTitle => _titleController.stream.transform(//faz a validação do conteúdo do campo de título da categoria
    StreamTransformer<String, String>.fromHandlers(
      handleData: (title, sink){
        if(title.isEmpty) {
          sink.addError('Insira um título');
        } else {
            sink.add(title);
        }
      }
    )
  );
  Stream get outImage => _imageController.stream;
  Stream<bool> get outDelete => _deleteController.stream;
  Stream<bool> get submitValid => Observable.combineLatest2(outTitle, outImage, (a, b) => null);//stream que valida se a combinação do título com a imagem

  DocumentSnapshot category;

  String title;
  File image;
  
  CategoryBloc(this.category){
    title = category.data['title'];

    if(category != null){
      _titleController.add(category.data['title']);
      _imageController.add(category.data['icon']);
      _deleteController.add(true);
    } else {
      _deleteController.add(false);
    }
  }

  void setImage(File file){
    image = file;
    _imageController.add(file);//vai passar um arquivo.
  }

  void setTitle(String title){
    this.title = title;
    _titleController.add(title);
  }

  Future saveData() async{
    if(image == null && category != null && title == category.data['title']) return; //se a imagem é igual a nulo, categoria diferente de nulo e title igual ao que está no firebase não salva nada

    Map<String, dynamic> dataToUpdate = {};

    if(image != null){//salva a imagem no storage do Firebase
      StorageUploadTask task = FirebaseStorage.instance.ref().child('icons')
        .child(title).putFile(image);//pasta será criada dentro de icons com nome do título e com a imagem dentro
      StorageTaskSnapshot snap = await task.onComplete;
      dataToUpdate['icon'] = await snap.ref.getDownloadURL();//icon mesmo nome que está no firebase
    }

    if(category == null || title != category.data['title']){
      dataToUpdate['title'] = title;
    }

    if(category == null){
      await Firestore.instance.collection('products').document(title.toLowerCase())
          .setData(dataToUpdate);//foi na coleção de produtos, criei um novo documento com o nome da categoria e dei um setData com os dados da categoria
    } else {//atualiza os dados da categoria com o datatoUpdate para atualizar os dados da categoria no firebase
      await category.reference.updateData(dataToUpdate);
    }

  }

  void delete(){
    category.reference.delete();
  }
  
  @override
  void dispose() {
    _titleController.close();
    _imageController.close();
    _deleteController.close();
  }
}