import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:my_tradebook/screens/login/screen_login.dart';
import 'package:my_tradebook/widgets/widget_appbar.dart';

class ScreenPositionSizing extends StatelessWidget {
  const ScreenPositionSizing({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 238, 238, 255),
      appBar: WidgetAppbar(title: 'Position Sizing'),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 70,
                ),
                Expanded(
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          return Text('hai');
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: 7,
                          );
                        },
                        itemCount: 50))
              ],
            ),
            Container(
              height: 70,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 0.5, color: Color.fromARGB(255, 206, 205, 205)),
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 233, 230, 237),
                      Color.fromARGB(255, 204, 200, 210),
                    ],
                  )),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Target Amount/Trade',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 80, 78, 78)),
                          ),
                          sizedBoxTen,
                          Text('1000',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 17)),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            'Target(%)',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 80, 78, 78)),
                          ),
                          sizedBoxTen,
                          Text('0.5%',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 17)),
                        ],
                      ),
                      Column(
                        children: [
                          Text('SL(%)',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 80, 78, 78),
                              )),
                          sizedBoxTen,
                          Text('0.3%',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 17)),
                        ],
                      ),
                      IconButton(onPressed: () {}, icon: Icon(Icons.edit))
                    ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
