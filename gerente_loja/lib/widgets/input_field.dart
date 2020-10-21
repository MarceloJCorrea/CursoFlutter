import 'package:flutter/material.dart';

class InputField extends StatelessWidget {

  final IconData icon;
  final String hint;
  final bool obscure;
  final Stream<String> stream;
  final Function(String) onChanged;

  InputField({this.icon, this.obscure, this.hint, this.stream, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: stream,
      builder: (context, snapshot) {
        return TextField(
          onChanged: onChanged,
          decoration: InputDecoration(//input de texto, por isso o input decoretaion
            icon: Icon(icon, color: Colors.white,), //icone que vai ser variavel e com cor branca
            hintText: hint, //dica do campo que vai ser variavel
            hintStyle: TextStyle(color: Colors.white),//estilo da dica do campo
            focusedBorder: UnderlineInputBorder(//borda que vai aparecer quando usuário clicar no campo
              borderSide: BorderSide(color: Colors.pinkAccent)//informa uma cor, um tamanho e um estilo
            ),
            contentPadding: EdgeInsets.only(//coloca um distanciamento entre os campos
              left: 5,
              right: 30,
              bottom: 30,
              top: 30
            ),
            errorText: snapshot.hasError ? snapshot.error : null//se tiver erro vai colcar o erro no campo errortext, se a stream retorna erro, mostra no errorText
          ),
          style: TextStyle(color: Colors.white),
          obscureText: obscure,
        );
      }
    );
  }
}
