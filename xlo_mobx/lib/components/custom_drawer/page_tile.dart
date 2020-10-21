import 'package:flutter/material.dart';

class PageTile extends StatelessWidget {//passa parâmetros para o page_section.dart

  PageTile({this.label, this.iconData, this.onTap, this.highlighted});

  final String label;
  final IconData iconData;
  final VoidCallback onTap;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        label,
        style: TextStyle(
            color: highlighted ?  Colors.purple : Colors.black87,
            fontWeight: FontWeight.w500,
        ),
      ),
      leading: Icon(
        iconData,
        color: highlighted ?  Colors.purple : Colors.black87,
      ),
      onTap: onTap,
    );

  }

}
