import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';

class ProductBloc extends BlocBase{

  final _dataController = BehaviorSubject<Map>();//Map porque vai conter todos os dados que quer exibir na tela productscreen
  final _loadingController = BehaviorSubject<bool>();
  final _createdController = BehaviorSubject<bool>();

  Stream<Map> get outData => _dataController.stream;
  Stream<bool> get outLoading => _loadingController.stream;
  Stream<bool> get outCreated => _createdController.stream;

  String categoryId;
  DocumentSnapshot product;

  Map<String, dynamic> unsavedData;//ao invés de modificar o dado diretamenta cria-se o mapa de daods não salvos e só vai salvar eles se clicar no botão save

  ProductBloc({this.categoryId, this.product}){
    if(product != null){//se ir na tela e clicar em um produto, vai executar essa parte
      unsavedData = Map.of(product.data);//está sendo clonado os dados do produto, colocando no unsavedData, dessa forma pode motificar o unsavedData que não vai modificar os dados do produto
      unsavedData['images'] = List.of(product.data['images']);//copia os dados do produto para poder modificar
      unsavedData['sizes'] = List.of(product.data['sizes']);//copia os dados do produto para poder modificar

      _createdController.add(true);//habilita o botão exclui se o produto já estiver criado
    } else{//caso o usuário não esteja clicando em um produto e sim clicando para adicionar, inicializa os parâmetros como vazios, nulos
      unsavedData = {
        'title': null,
        'description': null,
        'price': null,
        'images': [],
        'sizes': null,
      };
      _createdController.add(false);
    }

    _dataController.add(unsavedData);//transmite os dados pro DataControele ele vai sair para o OutData
  }

  void saveTitle(String title){
    unsavedData['title'] = title;
  }

  void saveDescription(String description){
    unsavedData['description'] = description;
  }

  void savePrice(String price){
    unsavedData['price'] = double.parse(price);//esse valor nunca vai ser um texto, pois garanto no validator, pois o validator sempre vai subir um erro e nunca vai chamar a função unsaved
  }

  void saveImages(List images){
    unsavedData['images'] = images;
  }

  void saveSizes(List size){
    unsavedData['sizes'] = size;
  }

  @override
  void dispose() {
    _dataController.close();
    _loadingController.close();
    _createdController.close();
  }
  
  Future<bool> saveProduct() async{//vai salvar todos os dados no firebase vai retornar um future<bool> pois é se deu certo ou não, true ou false
    _loadingController.add(true);//estou carregando

    try{
      if(product != null){//se já existe o produto vai atualizar a lista de imagens no firebase
        await _uploadImages(product.documentID);
        await product.reference.updateData(unsavedData);//passa os dados do produto e fazer fazer um update no firebase no produto que está editando
      } else {//DocumentReferente preciso da referencia do documento
        DocumentReference dr = await Firestore.instance.collection('products').document(categoryId).collection('itens').add(
          Map.from(unsavedData)..remove('images')//mandando remover as imgens do Mapa clone, pois a imagem ainda está em arquivo, será removida temporariamente e depois incluída
        );
        await _uploadImages(dr.documentID);//agora tem o id do documento
        await dr.updateData(unsavedData);//depois que fiz o upload das imagens agora sim posso fazer o update de todos os dados
      }
      _createdController.add(true);//habilita o botão exclui
      _loadingController.add(false);//não estou carregando
      return true;//retorno que deu certo

    } catch(e){
      _loadingController.add(false);//terminei de carregar, desta forma, todos os lugares que estiver olhando vai saer que está carregando
      return false;//indica que não deu certo o carregamento
    }
  }

  Future _uploadImages(String productId) async {
    for(int i = 0; i < unsavedData['images'].length; i++){//pegou a quantidade de imagens do unsavedData e tá fazendo i para cada um desses valores, então 0, 1, 2 e assim por diante
      if(unsavedData['images'][i] is String) continue;//verifica se o unsaved data é uma String, se for quer dizer que ele já está no firebase, já é uma url da imagem, o continue ignora toda a parte de baixo do for

      StorageUploadTask uploadTask = FirebaseStorage.instance.ref().child(categoryId)//salvar a imagem no Storage na pasta categoryID e dentro o product
          .child(productId).child(DateTime.now().millisecondsSinceEpoch.toString())//pasta productId com nome data hora atual em milisegundos para nunca ser igual
          .putFile(unsavedData['images'][i]);//salva em arquivo

      StorageTaskSnapshot s = await uploadTask.onComplete;//vai esperar o download da imagem ser completo
      String downloadUrl = await s.ref.getDownloadURL();//pega a url da imagem e salva na string downloadUrl

      unsavedData['images'][i] = downloadUrl;//unsavedData antes era arquivo agora é uma url
    }

  }

  void deleteProduct(){
    product.reference.delete();//delete o produto do Firebase
  }

}