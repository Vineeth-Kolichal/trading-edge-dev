import 'package:flutter/material.dart';
import 'package:my_tradebook/widgets/widget_appbar.dart';

class PageAboutTradeBokk extends StatelessWidget {
  const PageAboutTradeBokk({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 238, 238, 230),
      appBar: WidgetAppbar(title: 'About Tradebook'),
      body: SafeArea(
        child: Center(child: Text('about')),
      ),
    );
  }
}
