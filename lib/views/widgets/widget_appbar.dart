import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class WidgetAppbar extends StatelessWidget implements PreferredSize {
  @override
  Size get preferredSize => Size.fromHeight(height);

  final String title;
  final double height;
  final Widget? actions;
  const WidgetAppbar(
      {super.key,
      required this.title,
      this.height = kToolbarHeight,
      this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(color: Colors.black),
      ),
      iconTheme: const IconThemeData(color: Colors.black),
      leading: Builder(builder: (context) {
        return IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        );
      }),
      backgroundColor: Colors.white,
      actions: (actions == null) ? null : [actions!],
    );
  }

  @override
  Widget get child => throw UnimplementedError();
}
