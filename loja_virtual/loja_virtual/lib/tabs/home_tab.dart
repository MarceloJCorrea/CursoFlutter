import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    Widget _buldBodyBack() => Container(//cria um degradê de cores, inicia no rosa mais escuro e termina num rosa mais claro, começa no topo esquerdo e vai até embaixo na direita
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 211, 118, 138),//rosa mais escuro
            Color.fromARGB(255, 253, 181, 168)//rosa mais claro
          ],
          begin: Alignment.topLeft,//começa no canto superior esquerdo
          end: Alignment.bottomRight//termina no canto inferior direito
        )
      ),
    );

    return Stack(//permite colocar uma coisa em cima da outra
      children: <Widget>[
        _buldBodyBack(),
        CustomScrollView(//scroll customizado
          slivers: <Widget>[
            SliverAppBar(
              floating: true, //barra vai flutuar
              snap: true,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text('Novidades'),
                centerTitle: true,
              ),
            ),
            FutureBuilder<QuerySnapshot>(
              future: Firestore.instance.collection('home').orderBy('pos').getDocuments(),
              builder: (context, snapshot){
                if(!snapshot.hasData)
                  return SliverToBoxAdapter(
                    child: Container(
                      height: 200.0,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  );
                else {
                  print(snapshot.data.documents.length);
                  return SliverToBoxAdapter(
                    child: Container(
                      height: 200.0,
                      alignment: Alignment.center,
                      child: Container()
                    ),
                  );
                }
              },
            )
          ],
        )
      ],
    );
  }
}
