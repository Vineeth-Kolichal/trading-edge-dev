import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class Screen_login extends StatelessWidget {
  const Screen_login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('Welcome...'),
              Text('Login with Mobile'),
            ],
          ),
        ),
      ),
    );
  }
}
