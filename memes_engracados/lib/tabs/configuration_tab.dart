import 'package:flutter/material.dart';
import 'package:memesengracados/models/checkbox_model.dart';
import 'package:memesengracados/widgets/checkbox_widget.dart';

class ConfigurationTab extends StatefulWidget {
  @override
  _ConfigurationTabState createState() => _ConfigurationTabState();
}

class _ConfigurationTabState extends State<ConfigurationTab> {

  final List<CheckBoxModel> _itens = [
    CheckBoxModel(text: 'Receber Notificações', subtext: 'Receba o meme do dia diariamente em seu celular' , checked: true),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _itens.length,
      itemBuilder: (_, int index){
        return CheckBoxWidget(item: _itens[index],);
      },
    );
  }
}
