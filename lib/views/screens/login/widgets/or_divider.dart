import 'package:flutter/material.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(child: Divider()),
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Text(
              'OR',
              style: TextStyle(fontSize: 19),
            ),
          ),
          Expanded(
            child: Divider(),
          )
        ],
      ),
    );
  }
}