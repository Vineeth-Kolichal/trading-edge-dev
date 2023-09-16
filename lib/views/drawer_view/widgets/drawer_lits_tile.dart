import 'package:flutter/material.dart';

class DrawerListTileItem extends StatelessWidget {
  const DrawerListTileItem(
      {super.key,
      required this.leadingIcon,
      required this.title,
      required this.onTapFunction});
  final IconData leadingIcon;
  final String title;
  final Function() onTapFunction;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTapFunction,
      leading: Icon(
        leadingIcon,
        fill: 0,
      ),
      title: Text(title),
    );
  }
}