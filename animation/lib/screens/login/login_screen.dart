import 'package:animation/screens/login/widgets/form_container.dart';
import 'package:animation/screens/login/widgets/sign_up_button.dart';
import 'package:animation/screens/login/widgets/stagger_animation.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {

  AnimationController _animationController;//declaramos o animation

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(//inicializamos ele com o vsync e com a duração de 2 segundos
      vsync: this,
      duration: Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();//já demos dispose para liberar memória
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(//container para colocar a imagem dentro, poderia usar o stack
        alignment: AlignmentDirectional.bottomCenter,//alinhamento será para baixo no centro
        decoration: BoxDecoration(//colocar a imagem de fundo
          image: DecorationImage(
            image: AssetImage('images/background.jpg'),
            fit: BoxFit.cover //para que a imagem use toda a tela
          )
        ),
        child: ListView(//caso o teclado cubra, pode rolar a tela e digitar
          padding: EdgeInsets.zero,//para não ter borda
          children: <Widget>[
            Stack(//componente que pode por uma coisa em cima da outra, se não fosse fazer animação não precisaria dele
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(//afastar um pouco em cima e embaixo
                      padding: EdgeInsets.only(top: 70, bottom: 32),
                      child: Image.asset('images/ticket.jpg', width: 150, height: 150, fit: BoxFit.contain,),
                    ),
                    FormContainer(),
                    SignUpButton(),
                  ],
                ),
                StaggerAnimation(
                    controller: _animationController.view//animação que vai de 0 a 1
                )
              ],
            ),
          ],
        )
      ),
    );
  }
}
