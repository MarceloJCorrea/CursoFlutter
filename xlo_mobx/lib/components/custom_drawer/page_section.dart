import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:xlomobx/components/custom_drawer/page_tile.dart';
import 'package:xlomobx/stores/page_store.dart';

class PageSection extends StatelessWidget {

  final PageStore pageStore = GetIt.I<PageStore>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        PageTile(//utiliza os parâmetros da classe page_tile.dart
          label: 'Anúncios',
          iconData: Icons.list,
          onTap: (){
            pageStore.setPage(0);
          },
          highlighted: pageStore.page == 0,//coloca no drawer se está na pãgina selecionada
        ),
        PageTile(
          label: 'Inserir anúncio',
          iconData: Icons.edit,
          onTap: (){
            pageStore.setPage(1);
          },
          highlighted: pageStore.page == 1,
        ),
        PageTile(
          label: 'Chat',
          iconData: Icons.chat,
          onTap: (){
            pageStore.setPage(2);
          },
          highlighted: pageStore.page == 2,
        ),
        PageTile(
          label: 'Favoritos',
          iconData: Icons.favorite,
          onTap: (){
            pageStore.setPage(3);
          },
          highlighted: pageStore.page == 3,
        ),
        PageTile(
          label: 'Minha conta',
          iconData: Icons.person,
          onTap: (){
            pageStore.setPage(4);
          },
          highlighted: pageStore.page == 4,
        ),
      ],
    );
  }
}
