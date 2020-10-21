import 'package:flutter/material.dart';

class FieldTitle extends StatelessWidget {

  final String title;
  final String subtitle;

  FieldTitle({this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 3, bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
              '$title',
              style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 16,
                  fontWeight: FontWeight.w700
              )
          ),
          Text(
            '$subtitle',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12
            ),
          )
        ],
      )
    );
  }
}


