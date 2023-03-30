import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class WidgetAppbar extends StatelessWidget implements PreferredSize {
  @override
  Size get preferredSize => Size.fromHeight(height);

  final String title;
  final double height;
  const WidgetAppbar({required this.title, this.height = kToolbarHeight});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(color: Colors.black),
      ),
      iconTheme: const IconThemeData(color: Colors.black),
      leading: Builder(builder: (context) {
        return IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Get.back();
          },
        );
      }),
      backgroundColor: Colors.white,
    );
  }

  @override
  // TODO: implement child
  Widget get child => throw UnimplementedError();
}
