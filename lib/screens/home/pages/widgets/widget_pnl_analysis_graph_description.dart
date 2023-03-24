import 'package:flutter/material.dart';
import 'package:my_tradebook/screens/login/screen_login.dart';

Widget pnlGraphComponent() {
  return SizedBox(
    height: 40,
    width: double.infinity,
    child: Column(children: [
      pnlGraphRow('Intraday', const Color.fromARGB(255, 121, 241, 110),
          const Color.fromARGB(255, 245, 126, 117)),
      sizedBoxTen,
      pnlGraphRow('Swing', const Color.fromARGB(255, 35, 204, 1),
          const Color.fromARGB(255, 245, 3, 3))
    ]),
  );
}

Widget pnlGraphRow(String tradeType, Color color1, Color color2) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        height: 10,
        width: 10,
        color: color1,
      ),
      const SizedBox(
        width: 5,
      ),
      Text(
        'Profitable $tradeType Trades',
        style: const TextStyle(fontSize: 11),
      ),
      const SizedBox(
        width: 20,
      ),
      Container(
        height: 10,
        width: 10,
        color: color2,
      ),
      const SizedBox(
        width: 5,
      ),
      Text(
        'Lost $tradeType Trades',
        style: const TextStyle(fontSize: 11),
      ),
    ],
  );
}
