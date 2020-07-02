import 'package:animation/screens/login/widgets/imput_field.dart';
import 'package:flutter/material.dart';

class FormContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),//coloca na horizontal e centralizado
      child: Form(//validação nos campos, não terá nesse app
        child: Column(
          children: <Widget>[
            InputField(//vai buscar a formatação da classse imput_field
              hint: 'Username',
              obscure: false,
              icon: Icons.person_outline,
            ),
            InputField(
              hint: 'Password',
              obscure: true,
              icon: Icons.lock_outline,
            )
          ],
        ),
      ),
    );
  }
}
