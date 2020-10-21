import 'package:scoped_model/scoped_model.dart';

class CheckBoxModel extends Model{

  CheckBoxModel({this.text, this.subtext, this.checked});

  String text;
  String subtext;
  bool checked;

}