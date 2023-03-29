import 'package:flutter/material.dart';
import 'package:my_tradebook/widgets/widget_appbar.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetAppbar(title: 'Contact Us'),
      body: SafeArea(
        child: Center(child: Text('Contact us')),
      ),
    );
    
  }
}
