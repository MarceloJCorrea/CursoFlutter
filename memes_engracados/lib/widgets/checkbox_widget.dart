import 'package:flutter/material.dart';
import 'package:memesengracados/models/checkbox_model.dart';

class CheckBoxWidget extends StatefulWidget {

  const CheckBoxWidget({Key key, this.item}) : super(key: key);

  final CheckBoxModel item;

  @override
  _CheckBoxWidgetState createState() => _CheckBoxWidgetState();
}

class _CheckBoxWidgetState extends State<CheckBoxWidget> {
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
        title: Text(widget.item.text, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),),
        subtitle: Text(widget.item.subtext),
        value: widget.item.checked,
        onChanged: (bool value){
          setState(() {
            widget.item.checked = value;
          });
        }
    );
  }
}
