import 'dart:async';

class LoginValidators{

  final validateEmail = StreamTransformer<String, String>.fromHandlers(//StreamTransformer transforma um objeto em outro, neste caso uma entrada de String numa saída String
    handleData: (email, sink){//vai entrar o objeto email e sair o objeto sink
      if(email.contains('@')){//se o email que entrou tem o @ adciona na saída do tubo
        sink.add(email);
      } else
        sink.addError('Insira um e-mail válido');
    }
  );
  
  final validaPassword = StreamTransformer<String, String>.fromHandlers(
    handleData: (pass, sink){
      if(pass.length > 4){
        sink.add(pass);
      } else
        sink.addError('Insira uma senha com no mínimo 4 caracteres');
    }
  );

}