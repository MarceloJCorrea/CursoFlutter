import 'package:flutter/material.dart';

class StaggerAnimation extends StatelessWidget {

  final AnimationController controller;

  StaggerAnimation({this.controller}) : //inicializar a animação usando essa notaçaõ
      buttonSqueeze = Tween(
        begin: 320.0,
        end: 60.0,
      ).animate(
        CurvedAnimation(//pedacinho da animação inteira, não termina no 1, levará 0.3 para o botão diminuir
          parent: controller,
          curve: Interval(0.0, 0.150)//0.150 é a porcentagem da animanção, é 15% de 2 segundos que é quando termina essa animação
        ),
      ),
      buttonZoomOut = Tween(
          begin: 60.0, //largura e altura que vai iniciar o botão
          end: 1000.0, //1000 para cobrir realmente a tela inteira
        ).animate(
          CurvedAnimation(//faz uma animação bem rápido para cobrir a tela antes da outra
              parent: controller, // curve dentro do intervalo - curves dentro
              curve: Interval(0.5, 1.0, curve: Curves.bounceInOut)//a animação de cima termina em 0.15 e para 0.5 nada vai acontecer a bolinha ficará girando por 0.35 segudnos
          ),
      );


  final Animation<double> buttonSqueeze;
  final Animation<double> buttonZoomOut;

  Widget _buildAnimation(BuildContext context, Widget child){
    return Padding(
      padding: EdgeInsets.only(bottom: 50),//alinhamento de 50 para baixo
      child: InkWell(
        onTap: (){
          controller.forward();//tocar no botão faz a animação iniciar
        },
        child:
        buttonZoomOut.value <= 60 ? // se ele continua 60 de altura continua do jeito que tava
          Container(
            height: 60,//altura do botão
            width: buttonSqueeze.value,//largura do botão
            alignment: Alignment.center,//alinhamento do botão
            decoration: BoxDecoration(
              color: Color.fromRGBO(247, 64, 106, 1.0),//cor rosa do botão em hexadecimal e 1.0 é a opacidade
              borderRadius: BorderRadius.all(Radius.circular(30.0))//borda em volta do botão
            ),
          child: _buildInside(context)
          )
            : Container(
                height: buttonZoomOut.value,//altura do botão vai depender do bottão zoom out
                width: buttonZoomOut.value,//largura do botão vai depender do bottão zoom out
                decoration: BoxDecoration(
                  color: Color.fromRGBO(247, 64, 106, 1.0),//cor rosa do botão em hexadecimal e 1.0 é a opacidade
                  shape: buttonZoomOut.value < 500 ?
                      BoxShape.circle : BoxShape.rectangle // começa crescento como circulo e termina como retângulo
              ),
             )
      ),
    );
  }

  Widget _buildInside(BuildContext context){

    if(buttonSqueeze.value > 75){//enquanto a largura for de 75 vai ainda mostrar o texto SignIN
      return Text(//text do botão
        'Sign In',
        style: TextStyle(//estilo do botão
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w300,
            letterSpacing: 0.3
        ),
      );
      } else {//quando for menor que 75 irá mostrar a bolinha girando
        return CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),//cor da bolinha girando
          strokeWidth: 1.0,//largura da bolinha girando
        );
      }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }
}
