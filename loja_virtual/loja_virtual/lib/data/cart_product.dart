import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lojavirtual/data/products_data.dart';

class CartProduct{

  String cid; //id do produto no carrinho

  String category;//armazena a categoria para saber qual categoria que o produto está
  String pid;//armazenar o id do produto

  int quantity;//armazena a quantidade, ela não vai mudar quando já estiver adicionada no carrinho
  String size;//armazena o tamanho, tambem não muda se já tiver no carrinho

  ProductData productData;//dados do produto da classe product_data, dados do produto não serão armazendos permanentemente no produto mas ela precisa aparecer no carrinho

  CartProduct(); //construtor vazio

  CartProduct.fromDocument(DocumentSnapshot document){//vai receber todos os produtos do carrinho e vai transformar num CardProduct
    cid = document.documentID;
    category = document.data['category'];
    pid = document.data['pid'];
    quantity = document.data['quantity'];
    size = document.data['size'];
  }

  Map<String, dynamic> toMap(){//armazena os dados do carrinho no banco de dados
    return {
      'category': category,
      'pid': pid,
      'quantity': quantity,
      'size': size,
      //'productData': productData.toResumedMap(), //armazena um resumo somente, pois para acompanhar os meus pedidos não aparecerão todos os dados, somente um resumo
    };
  }
}