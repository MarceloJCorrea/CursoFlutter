import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:xlomobx/screens/create/create_screen.dart';
import 'package:xlomobx/screens/home/home_screen.dart';
import 'package:xlomobx/stores/page_store.dart';

class BaseScreen extends StatefulWidget {

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final PageController pageController = PageController();

  final PageStore pageStore = GetIt.I<PageStore>();


  @override
  void initState() {//vai rodar sempre que o widget iniciar
    super.initState();

    reaction((_) => pageStore.page,//semque que tiver uma modificação no page do pageSotre vai chamar a funçaõ de baixo passando a página atual e vai chamar o jumptopage para ir para a página atual
    (page) => pageController.jumpToPage(page)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(//base de praticamente todas as telas, traz temas do material desing
      body: PageView(//altera de uma tela para outra
        controller: pageController,//utilizado para mudar de data
        physics: NeverScrollableScrollPhysics(),//não deixa mudar a página pelo dedo
        children: <Widget>[
          HomeScreen(),
          CreateScreen(),
          Container(color: Colors.black54,),
          Container(color: Colors.green,),
          Container(color: Colors.yellow,),
        ],
      ),
    );
  }
}
