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

  double getProductsPrice(){//retornar e calcular o preço do produto no carrinho
    double price = 0.00;//inicia o preço em zero
    for (CartProduct c in products){//pega cada um dos produtos e colocar em c
      if(c.productData != null)//se o c já tiver carregado o productDate vai incrementar o preço
        price += c.quantity * c.productData.price;//pega a quantidade do produto e multiplica pelo preço e adiciona no price
    }
    return price;

  }

  double getDiscount(){//retorna o desconto
    return getProductsPrice() * discountPercentage / 100; //pega a porcetagem de desconto e multiplica pelo preço total dos produtos
  }

  double getShipPrice(){//retorna o valor da entrega
    return 9.99;//preço do frete fixo
  }

  Future<String> finishOrder() async {//função que fecha o pedido e atualiza o carrinho na tela, apaga os produtos do carrinho e apaga no firestore também.
    if (products.length == 0)
      return null; //verifica se a lista de produtos está diferente de vazia.

    isLoading = true;

    notifyListeners();

    double productsPrice = getProductsPrice(); //retorna o preço dos produtos
    double shipPrice = getShipPrice(); //retorna o frete
    double discount = getDiscount(); //retorna o desconto

    //obtem a referencia do pedido para salvar no usuário depois
    DocumentReference refOrder = await Firestore.instance.collection('orders').add( //cria a coleção no banco de dados do Firestore "orders".
        {
          "clienteId": user.firebaseUser.uid, //pega o uid do cliente para adicionar no pedido do cliente
          "products": products.map((cartProduct) => cartProduct.toMap())
              .toList(),//transforma cada CartProduct em um mapa para acionar no banco de dados
          "shipPrice": shipPrice,
          "productsPrice": productsPrice,
          "discount": discount,
          "totalPrice": productsPrice + shipPrice - discount,
          "status": 1,//status que informa que está preparando
        }
    );

    Firestore.instance.collection("users").document(user.firebaseUser.uid).
    collection("orders")
        .document(refOrder.documentID). //acessa a coleção do usuário para adicionar a referencia do pedido dentro do cliente que fez o pedido
    setData({
      "orderId": refOrder.documentID, //salva a refeerendia do pedido no cliente
    });

    QuerySnapshot query = await Firestore.instance.collection("users").document(
        user.firebaseUser.uid).collection("cart").getDocuments();

    for (DocumentSnapshot doc in query.documents) { //pega cada um dos documentos da lista do carrinho, cada um dos produtos do carrinho, pega a refereência dele e vai deletar
      doc.reference.delete();
    }

    products.clear();
    couponCode = null;
    discountPercentage = 0;

    isLoading = false;
    notifyListeners();

    return refOrder.documentID; //retorna o numero do pedido para apresentar ao usuário o número do pedido que foi concluído depois

  }

  void updatePrices(){//atualiza os valores no carrinho caso haja alteração
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