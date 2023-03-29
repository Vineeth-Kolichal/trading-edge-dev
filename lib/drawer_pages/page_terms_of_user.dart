import 'package:flutter/material.dart';
import 'package:my_tradebook/widgets/widget_appbar.dart';

class PageTermsOfUser extends StatelessWidget {
  const PageTermsOfUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetAppbar(title: 'Terms of use'),
      body: SafeArea(
        child: Center(child: Text('terms of use')),
      ),
    );
  }
}
