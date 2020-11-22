import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memesengracados/data/memes_data.dart';
import 'package:scoped_model/scoped_model.dart';

class MemesModal extends Model{
  
  List<MemesData> memes = [];
  
  bool isLoading = false;

  void loadingImages() async{
    
    isLoading = true;

    DocumentSnapshot query = await FirebaseFirestore.instance.collection('images').doc().get();

    notifyListeners();

    isLoading = false;

  }

}