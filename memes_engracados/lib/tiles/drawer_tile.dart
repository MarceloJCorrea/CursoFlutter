import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {

  final IconData icon;
  final String text;
  final PageController controller;
  final int page;

  DrawerTile(this.icon, this.text, this.controller, this.page);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: (){
          Navigator.of(context).pop();
          controller.jumpToPage(page);
        },
        child: Container(
          height: 60.0,
          child: Row(
            children: [
              Icon(
                icon,
                size: 16.0,
                color: controller.page == page? Theme.of(context).primaryColor : Colors.grey,
              ),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16.0,
                  color: controller.page == page? Theme.of(context).primaryColor : Colors.grey,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
