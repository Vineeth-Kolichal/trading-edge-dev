import 'package:flutter/material.dart';
import 'package:trading_edge/utils/constants/constant_widgets.dart';

Widget pnlGraphComponent(BuildContext context) {
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.054,
    width: MediaQuery.of(context).size.width,
    child: ListView(physics: const NeverScrollableScrollPhysics(), children: [
      pnlGraphRow('Intraday', const Color.fromARGB(255, 121, 241, 110),
          const Color.fromARGB(255, 245, 126, 117), context),
      sizedBoxTen,
      pnlGraphRow('Swing', const Color.fromARGB(255, 35, 204, 1),
          const Color.fromARGB(255, 245, 3, 3), context)
    ]),
  );
}

Widget pnlGraphRow(
    String tradeType, Color color1, Color color2, BuildContext context) {
  return SizedBox(
    width: 30,
    child: Row(
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
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
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
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'Lost $tradeType Trades',
          style: const TextStyle(fontSize: 11),
        ),
      ],
    ),
  );
}
