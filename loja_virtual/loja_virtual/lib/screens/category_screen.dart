import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/data/products_data.dart';
import 'package:lojavirtual/tiles/product_tile.dart';

class CategoryScreen extends StatelessWidget {

  final DocumentSnapshot snapshot; //variavel do tipo snaphot

  CategoryScreen(this.snapshot); //construtor

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // terá duas guias que o usuário escolhe se quser lista ou lado a lado
      child: Scaffold(
        appBar: AppBar(
          title: Text(snapshot.data["title"]),//texto do app bar que será mostrado em cima será o da categoria escolhida.
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white,//cor que a guia selecionada ficará
            tabs: <Widget>[
              Tab(icon: Icon(Icons.grid_on),),
              Tab(icon: Icon(Icons.list),)
            ],
          ),
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: Firestore.instance.collection("products").document(snapshot.documentID).collection('itens').getDocuments(),//irá buscar as informação da categoria que estamos, exemplo camisetas e o que está dentro de itens dele dentro do firestore
          builder: (context, snapshot){
            if(!snapshot.hasData)//se não retornar dados ficará o circulo rodando
               return Center(child: CircularProgressIndicator(),);
            else //se retornar os dados irá mostrar no grid ou lista do TabbarView
              return
                TabBarView(//irá mostrar as guias dos Tabs
                  physics: NeverScrollableScrollPhysics(), //desativa a passagem de uma guia para outra pelo passar para o lado, força usar os icones
                  children: <Widget>[
                    GridView.builder(//como será exibido o grid na tela com os produtos
                      padding: EdgeInsets.all(4.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(//como será exibido o grid na tela, formatação, espaçamento, quantidade de itens na grid
                        crossAxisCount: 2, //qauntidade de itens na grid por linha
                        childAspectRatio: 0.65, //razão da altura pela largura terá o aspectradio
                        crossAxisSpacing: 4.0,// espaçamento do eixo principal
                        mainAxisSpacing: 4.0, //espaçamento do eixo cruzado
                      ),
                      itemCount: snapshot.data.documents.length,//tamanho da grid
                      itemBuilder: (context, index){//dados a exibir do firestore
                        ProductData data = ProductData.fromDocument(snapshot.data.documents[index]);//irá buscar os dados da classe ProductTile, caso mude de banco de dados, só iria precisar alterar o código nessa classe e não em todos os pontos que chamar o firestore
                        data.category = this.snapshot.documentID; //this.snapshot pois indica cada categoria do nosso document que irá retornaar do banco. Pega cada categoria do produto e salva dentro do próprio produto para poder utilizá-lo no product_screen
                        return ProductTile("grid", data);//recebe o que o data obteve de resultado, esta é uma forma de guardar a categoria do produto no carrinho
                      },
                    ),
                    ListView.builder(//como será listado em lista os produtos
                      padding: EdgeInsets.all(4.0),//espaçamento
                      itemCount: snapshot.data.documents.length,//tamanho da lista
                      itemBuilder: (context, index){//dados a exibir do firestore
                        ProductData data = ProductData.fromDocument(snapshot.data.documents[index]); //irá buscar os dados da classe ProductTile, caso mude de banco de dados, só iria precisar alterar o código nessa classe e não em todos os pontos que chamar o firestore
                        data.category = this.snapshot.documentID;
                        return ProductTile("list", data);//recebe o que o data obteve de resultado, esta é uma forma de guardar a categoria do produto no carrinho
                      },
                    )
                  ],
                );
          }
        )
      ),
    );
  }
}
