import 'package:animation/screens/home/widgets/list_data.dart';
import 'package:flutter/material.dart';

class AnimatedListView extends StatelessWidget {

  final Animation<EdgeInsets> listSlidePosition;

  AnimatedListView({@required this.listSlidePosition});

  @override
  Widget build(BuildContext context) {
    return Stack(//consegue por um card um em cima do outro
      alignment: Alignment.bottomCenter,//alinhamento abaixo
      children: <Widget>[
        ListData(
          title: 'Estudar Flutter',
          subtitle: 'Com o Marcelão',
          image: AssetImage('image/background.jpg'),
          margin: listSlidePosition.value * 0,
        ),
        ListData(
          title: 'Estudar Euro Truck',
          subtitle: 'Com o Marcelão',
          image: AssetImage('image/background.jpg'),
          margin: listSlidePosition.value * 1,
        ),
        ListData(
          title: 'Estudar Flutter',
          subtitle: 'Com o Marcelão',
          image: AssetImage('image/background.jpg'),
          margin: listSlidePosition.value * 2,
        ),
        ListData(
          title: 'Estudar Flutter',
          subtitle: 'Com o Marcelão',
          image: AssetImage('image/background.jpg'),
          margin: listSlidePosition.value * 3,
        ),
        ListData(
          title: 'Estudar Flutter',
          subtitle: 'Com o Marcelão',
          image: AssetImage('image/background.jpg'),
          margin: listSlidePosition.value * 4,
        ),
      ],
    );
  }
}
