import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:xlomobx/screens/base/base_screen.dart';
import 'package:xlomobx/stores/page_store.dart';
import 'package:xlomobx/stores/user_manager_store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();//garantir que o binding do flutter está inicializado para depois iniciar o Parse
  await initiazeParse();//inicia o Parse primeiramente no app
  setupLocators();//sempre que pedir o pageStore vai sempre obter o mesmo, usando o get it para procurar o widget no app
  runApp(MyApp());
}

Future<void> initiazeParse() async{
  await Parse().initialize(
    'MHggIIpWnS0PnJZTEyUdLoLJ79EnSk855RMhRsiC',
    'https://parseapi.back4app.com/',
    clientKey: 'bw89GcPNAam1TegtbgieI9Mzl8wCD3ngsUBg8KPi',
    autoSendSessionId: true, //não precisa ficar informando quem a gente é
    debug: true, //true que o parse faz mostr ano console
  );
}

void setupLocators(){
  GetIt.I.registerSingleton(PageStore());//registra uma instancia do pageStore
  GetIt.I.registerSingleton(UserManagerStore());//tornar acessível de qlqr lugar do app
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XLO',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.purple,//cor primária do app
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.purple,//fundo roxo no app inteiro
        appBarTheme: AppBarTheme(
          elevation: 0
      ),
        cursorColor: Colors.orange//muda a cor padrão do cursor no app
      ),
      home: BaseScreen(),
    );
  }
}
