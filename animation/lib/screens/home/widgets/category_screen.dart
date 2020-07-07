import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  List<String> categories = [//declara variável e passa o conteúdo da lista
    'Estudar',
    'Trabalho',
    'Casa',
  ];

  int _category = 0;//variavel que vai ser o elemento da lista

  void selectForward(){
    setState(() {
      _category ++;//adciona mais um na categoria para passar para frente na lista
    });
  }


  void selectBack(){
    setState(() {
      _category --;//remove um na categoria para voltar para traz
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,//usa o espado da linha por completo
      children: <Widget>[
        IconButton(
          icon: Icon(
            Icons.arrow_back_ios,// ícone para ir para traz
            color: Colors.white,
          ),
          onPressed: _category > 0 ? selectBack : null, //só habilita o icone para ir para traz se a lista for maior que 0, lista começa sempre no zero e é incrementada com +1
          disabledColor: Colors.white10,//cor do botão quando ficar desabilitado
        ),
        Text(
          categories[_category].toUpperCase(),//mostra o texto com o conteúdo da lista convertido para maíusculo
          style: TextStyle(
            fontWeight: FontWeight.w300,
            letterSpacing: 1.2,//espaçamento entre as letras
            fontSize: 17.0,
            color: Colors.white
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.arrow_forward_ios,//icone para ir para frente
            color: Colors.white,
          ),
          onPressed: _category < categories.length - 1 ? selectForward : null, //habilita o botão somente se o tamanho da lista -1, no exemplo da lista acima, ela vai de 0,1,2, no 3 ficará desabilitado
          disabledColor: Colors.white12,
        ),
      ],
    );
  }
}

