import 'package:flutter/material.dart';
import 'package:xlomobx/components/custom_drawer/page_section.dart';
import 'custom_drawer_header.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(//consegue cortar qlqr widget
      borderRadius: BorderRadius.horizontal(right: Radius.circular(50)),//vai cortar a borda do drawer
      child: SizedBox(//limita o tamanho do drawer
        width: MediaQuery.of(context).size.width * 0.65, //pega 0.65 da tela para o tamanho do drawer
        child: Drawer(
          child: ListView(
            children: <Widget>[
              CustomDrawerHeader(),
              PageSection(),
            ],
          ),
        ),
      ),
    );
  }
}
