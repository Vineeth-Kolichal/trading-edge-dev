import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:my_tradebook/main.dart';
import 'package:my_tradebook/screens/login/screen_login.dart';

class WidgetFundTile extends StatelessWidget {
  const WidgetFundTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: whiteColor,
        ),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('March14'),
            Divider(),
            GridView.count(
              childAspectRatio: 3,
              shrinkWrap: true,
              //primary: true,
              padding: const EdgeInsets.all(8),
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              crossAxisCount: 2, physics: const NeverScrollableScrollPhysics(),
              // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              //     crossAxisCount: 2, childAspectRatio: 3),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Transaction Type'),
                    sizedBoxTen,
                    Text('Deposite')
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Transaction Amount'),
                    sizedBoxTen,
                    Text('100'),
                  ],
                )
              ],
            )
          ]),
        ),
      ),
    );
  }
}
