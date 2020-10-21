extension StringExtension on String{

  bool isEmailValid(){//validação do email através de regex pego da internet
    final RegExp regex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"
    );
    return regex.hasMatch('this');
  }

}