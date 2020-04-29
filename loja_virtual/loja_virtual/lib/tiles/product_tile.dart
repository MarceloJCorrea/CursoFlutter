import 'package:flutter/material.dart';
import 'package:lojavirtual/data/products_data.dart';
import 'package:lojavirtual/screens/product_screen.dart';

class ProductTile extends StatelessWidget {

  final String type; //variavel type do tipo string
  final ProductData product; //variavel do tipo ProductData

  ProductTile(this.type, this.product);

  @override
  Widget build(BuildContext context) {
    return InkWell(//permite clicar no produto e ver detalhes e mostra um efeito a clicar
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context)=>ProductScreen(product))
        );
      },
      child: Card(//cartão branco que tem um elevação e permite incluir imagens, texto, etc
        child: type=='grid'? //se for grid retorna uma coluna, senão (se for list) retorna uma linha
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch, //deixa as coisas esticadas
              mainAxisAlignment: MainAxisAlignment.start, //deixa as coisas começando no topo, no início do Card
              children: <Widget>[
                AspectRatio(//largura dividido pela altura dá 0,8, se quisesse a imagem quadrada era 1.0
                  aspectRatio: 0.8,
                  child: Image.network(
                    product.images[0],//exibe a primeira imagem da lista, 0 mostra a primeira imagem
                    fit: BoxFit.cover,//cobre todo o espaço disponível da imagem
                  ),
                ),
                Expanded(//pega todo o espaço disponível
                  child: Container(//container somente para colocar o espaçamento entre a imagem e o texto e as borcas do lado, acima e embaixo
                    padding: EdgeInsets.all(8.0),//espaçamento
                    child: Column(
                      children: <Widget>[
                        Text(
                          product.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w500
                          ),
                        ),
                        Text(
                          "R\$  ${product.price.toStringAsFixed(2)}",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,//cor de thema do app
                            fontSize: 17.0,//fonte do texto do preço
                            fontWeight: FontWeight.bold
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            )
            :Row(
              children: <Widget>[
                Flexible(//deixa os dois componentes na linha com o mesmo tamanho mesmo que seja para dispositivos de tamanhos diferentes (resolução)
                  flex: 1,
                  child: Image.network(
                    product.images[0],//exibe a primeira imagem da lista, 0 mostra a primeira imagem
                    fit: BoxFit.cover,//cobre todo o espaço disponível da imagem
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, //coloca o container com o nome do produto e preço alinhado ao começo
                    children: <Widget>[
                      Text(
                        product.title,
                        style: TextStyle(
                            fontWeight: FontWeight.w500
                        ),
                      ),
                      Text(
                        "R\$  ${product.price.toStringAsFixed(2)}",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,//cor de thema do app
                            fontSize: 17.0,//fonte do texto do preço
                            fontWeight: FontWeight.bold
                        ),
                      )
                    ],
                  ),
                )
              ],

            )
      ),
    );
  }
}
