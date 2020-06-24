import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: LogoApp()
    );
  }
}

class LogoApp extends StatefulWidget {
  @override
  _LogoAppState createState() => _LogoAppState();
}

class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin {

  AnimationController controller;
  Animation<double> animation; //classe abstrata que recebe uma animação, pode ser animação de image, cor, de qlqr coisa
  Animation<double> animation2;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(//controler vai de 0 a 1 e a animação vai de 0 a 300, se o controller estiver 0,5, a animação vai ser 150
        vsync: this, //this vai chamar o SingleTickerProvider, informa quando a reinderização acontece para animar a tela
        duration: Duration(seconds: 2)
    );

    //inicializa a animação, vai de 0 a 300, Tween é um widget
    animation = Tween<double>(begin: 0, end: 300).animate(controller);
    animation.addStatusListener((status) {//animação vai ficar indo e voltando.
      if(status == AnimationStatus.completed){//animação chegou ao fim, foi concluída
        controller.reverse();//vai para traz
      } else if(status == AnimationStatus.dismissed){//anda para trás na aninamação e chega no zero
        controller.forward();//vai para frente
      }

    });//é chamado toda vez que o estado da animação muda

    //inicializa a animação, vai de 0 a 300, Tween é um widget
    animation2 = Tween<double>(begin: 0, end: 150).animate(controller);
    animation2.addStatusListener((status) {//animação vai ficar indo e voltando.
      if(status == AnimationStatus.completed){//animação chegou ao fim, foi concluída
        controller.reverse();//vai para traz
      } else if(status == AnimationStatus.dismissed){//anda para trás na aninamação e chega no zero
        controller.forward();//vai para frente
      }

    });//é chamado toda vez que o estado da animação muda

    controller.forward();//animar para frente, animar para tras controller.reverse
  }

  @override
  void dispose() {//libera os recursos do controller, memória da máquina
    controller.dispose();
    super.dispose();
  } //controlador da animação


  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GrowTransition(
          child: LogoWidget(),
           animation: animation,
        ),//retorna o AnimatedLogo e passa a animação
        GrowTransition(
          child: LogoWidget(),
          animation: animation2,
        )
      ],
    );
  }
}

/*class AnimatedLogo extends AnimatedWidget{//cria o Animated Logo e estende o AnimatedWidget

  AnimatedLogo(Animation<double> animation) : super(listenable: animation);//declara o construtor e pode passar várias aniamções

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;

    return Center(//centraliza na tela o logo
      child: Container(//vai variar o tamanho da altua e largura de 0 a 300
        height: animation.value,
        width: animation.value,
        child: FlutterLogo(),
      ),
    );
  }
}*/

class LogoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlutterLogo(),
    );
  }
}

class GrowTransition extends StatelessWidget {

  final Widget child;
  final Animation<double> animation;

  GrowTransition({this.child, this.animation});//construtor, então sempre que quiser fazer qualquer widget aumentar ou diminuir, chama o growtranstion e passa o child e a animation, animation para que possa aumentar, diminuir, aumentar tamanho

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(//ele pega uma animação e toda vez que o valor da animação mudar refaz o widget, apenas esse widget
        animation: animation,
        builder: (context, child){
          return Container(
            height: animation.value,
            width: animation.value,
            child: child//parâmetro que vai passar
          );
        },
        child: child,//filho do animationBuilder
      ),
    );
  }
}




