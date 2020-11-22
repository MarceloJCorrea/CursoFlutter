import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/models/cart_model.dart';

class DiscountCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0), //margem igual ao dos produtos para ficar igual
      child: ExpansionTile(//é uma tile que é possível expandir para ver ou adicionar conteúdo
        title: Text(//título da tile com texto e formatação
          "Cupom de desconto",
          textAlign: TextAlign.start,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700]
          ),
        ),
        leading: Icon(Icons.card_giftcard),//ícone do lado esquerdo
        trailing: Icon(Icons.add),//ícone do lado direito
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(//campo onde será possível colocar o código do cupom de desconto
              decoration: InputDecoration(
                border: OutlineInputBorder(),//borda do campo Digite seu cupom
                hintText: "Digite seu cupom"//hint do campo que irá preenche ro cupom
              ),
              initialValue: CartModel.of(context).couponCode ?? "",//carrega o cupom de desconto do carrinho e caso não tenha aparece "", nada.
              onFieldSubmitted: (text){
                FirebaseFirestore.instance.collection('coupons').doc(text).get().then((docSnap){//busca o cupom lá no Firebase e pega o 'text' que o usuário digitou e salva no docSnap para validar
                  CartModel.of(context).setCoupon(text, docSnap.data()['percent']);//se tiver o cupom no firebase, salva o cupom e o percentual no carrinho
                  if(docSnap.data != null){//verifica se o cupom é válido
                    Scaffold.of(context).showSnackBar(//se for mostra para o usuário que o cupom foi aplicado
                      SnackBar(content: Text("Desconto de ${docSnap.data()['percent']}% aplicado"),
                      backgroundColor: Theme.of(context).primaryColor,)
                    );
                  }else {//senão mostra que o cupom é inválido
                    CartModel.of(context).setCoupon("", 0);//se o cupom é inválido set nulo na função que seta o cupom no carrinho e percentual 0
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text("Cupom inválido"),
                        backgroundColor: Colors.redAccent,)
                    );
                  }
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
