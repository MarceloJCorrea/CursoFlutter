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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 50.0,
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20.0,
                  color: controller.page == page? Theme.of(context).primaryColor : Colors.black,
                ),
                Padding(padding: EdgeInsets.only(left: 10)),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                    color: controller.page == page? Theme.of(context).primaryColor : Colors.black,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
