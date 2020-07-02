import 'package:flutter/material.dart';

class InputField extends StatelessWidget {

  final String hint;
  final bool obscure;
  final IconData icon;

  InputField({this.icon, this.hint, this.obscure});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(//borda do container que vai ter o username e senha
          bottom: BorderSide(
            color: Colors.white24,
            width: 0.5,
          )
        )
      ),
      child: TextFormField(
        obscureText: obscure,//texto ficará visível ou não, password não, username visívle
        style: TextStyle(
          color: Colors.white
        ),
        decoration: InputDecoration(
          icon: Icon(
            icon,//icone que buscará da variavel
            color: Colors.white,
          ),
          border: InputBorder.none,//nome para não ter borda nos campos e buscar a borga do container
          hintText: hint,//texto do hint que vai passar para a variavel
          hintStyle: TextStyle(//formatação do texto do hint
            color: Colors.white,
            fontSize: 15,
          ),
          contentPadding: EdgeInsets.only(//afastamento das laterais do conteúdo
            top: 30,
            right: 30,
            bottom: 30,
            left: 5
          )
        ),
      ),
    );
  }
}
