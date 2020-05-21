import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtual/data/cart_product.dart';
import 'package:lojavirtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model{

  List<CartProduct> products = []; //lista que vai ter todos os produtos do carrinho, declaro uma lista vazia

  UserModel user; //recebe o usuaário do user model

  String couponCode; //variável do código do cupom
  int discountPercentage = 0;//porcentagem do cupom

  CartModel(this.user){
    if(user.isLoggedIn())//se estiver logado carrega os produtos do carrinho que estão no firebase
      _loadCartItens();
  }//carrinho vai ter acesso ao usuário atual, se mudar de usuário vai ter outros produtos

  bool isLoading = false;//inicia a variavel de que está carregando com false

  //desta forma pode-se acessar o CartModel de qualquer lugar de uma forma muito simples
  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  void addCartItem(CartProduct cartProduct){//adciona produto no carrinho
    products.add(cartProduct);

    Firestore.instance.collection('users').document(user.firebaseUser.uid)//pega o carrinho do usuário no Firestore
        .collection('cart').add(cartProduct.toMap()).then((doc){//entra na coleção cart e adiciona num mapa, que já tem função criada no cart_product
       cartProduct.cid = doc.documentID;//armazena o cid do produto no carrinho par
      // a ser possível remover depois
    });
    notifyListeners();//notifica os listeners, porque acabou de adicionar o novo item no carrinho e quer que liste esse novo produto no carrinho
  }

  void removeCartItem(CartProduct cartProduct){//remove produto do carrinho
    Firestore.instance.collection('users').document(user.firebaseUser.uid).
       collection('cart').document(cartProduct.cid).delete();//delete o documento de um produto dentro do carrinho

    products.remove(cartProduct);//remove o produto da lista de produtos do carrinho

    notifyListeners();

  }


  void decProduct(CartProduct cartProduct){
    cartProduct.quantity--;//deleta um item do carrinho

    Firestore.instance.collection('users').document(user.firebaseUser.uid).collection('cart').document(cartProduct.cid).updateData(cartProduct.toMap()); //excluir o produto no firebase, produto que está no carrinho

    notifyListeners();
  }

  void incProduct(CartProduct cartProduct){
    cartProduct.quantity++;//adiciona mais um item no carrinho

    Firestore.instance.collection('users').document(user.firebaseUser.uid).collection('cart').document(cartProduct.cid).updateData(cartProduct.toMap()); //excluir o produto no firebase, produto que está no carrinho

    notifyListeners();
  }

  void _loadCartItens() async {
    QuerySnapshot query = await Firestore.instance.collection('users').document(
        user.firebaseUser.uid).collection('cart').getDocuments();

    products = query.documents.map((doc) => CartProduct.fromDocument(doc))
        .toList(); //transformando cada documento que retornou do firebase em um CartProduto, depois retorno uma lista com todos os CartProducts na lista de produtos

    notifyListeners();
  }

  void setCoupon(String couponCode, int discountPercentage){//aplicar desconto no carrinho
    this.couponCode = couponCode; //salvar o código do cupom
    this.discountPercentage = discountPercentage; //salvar a porcentagem
  }
}