import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerenteloja/screens/product_screen.dart';
import 'package:gerenteloja/widgets/edit_category_dialog.dart';

class CategoryTile extends StatelessWidget {

  DocumentSnapshot category;

  CategoryTile(this.category);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        child: Card(
            child: ExpansionTile( //tiles que vão expandir
              leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                //vai deixar o fundo transparente, só aparecer o icone
                backgroundImage: NetworkImage(
                    category.data['icon']), //icone que vem do firebase
              ),
              title: Text(
                category.data['title'], //título que vem do firebase
                style: TextStyle(
                    color: Colors.grey[500], fontWeight: FontWeight.w500),
              ),
              children: <Widget>[ //é o que vai aparecer quando expandir a tile
               FutureBuilder<QuerySnapshot>(//recuperar a lista de documentos
                  future: category.reference.collection('itens').getDocuments(),
                  builder: (context, snapashot){
                    if(!snapashot.hasData) return Container();
                    return Column(
                      children: snapashot.data.documents.map((doc){//para cada um dos documentos retorna um listTile
                        return ListTile(//caso a lista esteja vazia, só aparecerá o botão para adicionar os novos produtos, pois esta lista vai aparecer vazia
                          leading: GestureDetector(
                            onTap: (){
                              showDialog(context: context, builder: (context) => EditCategoryDialog(
                                category: category,//passa a caterogia como parâmetro
                              ));
                            },
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(doc.data['images'][0]),//temos uma lista de imagens, quero a imagem 0
                            ),
                          ),
                          title: Text(doc.data['title']),
                          trailing: Text(
                            'R\R${doc.data['price'].toStringAsFixed(2)}'
                          ),
                          onTap: (){
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => ProductScreen(
                                categoryId: category.documentID,//quando estiver alterando um produto precisa passar a categoria desse produto para a próxima tela
                                product: doc,//passando o produto para a próxima tela
                              ))
                            );
                          },
                        );
                      }).toList()..add(//utiliza notação para que já seja possível adicionar na lista novos produtos
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Icon(Icons.add, color: Colors.pinkAccent,),
                          ),
                          title: Text('Adicionar'),
                          onTap: (){
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => ProductScreen(
                                  categoryId: category.documentID,//quando estiver incluindo produto, passa a categoria que será criado o produto
                                ))
                            );
                          },
                        )
                      )
                    );
                  },
               )
              ],
            )
        )
    );
  }
}

