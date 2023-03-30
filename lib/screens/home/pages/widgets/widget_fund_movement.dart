import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:my_tradebook/main.dart';

class WidgetFundMovement extends StatelessWidget {
  const WidgetFundMovement({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: whiteColor,
      borderRadius: BorderRadius.circular(13),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text(
              'Fund Movement',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 200,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  const RotatedBox(quarterTurns: 3, child: Text('Fund--->')),
                  const SizedBox(width: 8),
                  Column(
                    children: [
                      SizedBox(
                        height: 180,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: DChartLine(
                          includePoints: true,
                          data: [
                            {
                              'id': 'Line',
                              'data': [
                                {'domain': 1, 'measure': 00},
                                {'domain': 2, 'measure': 21},
                                {'domain': 3, 'measure': 55},
                                {'domain': 4, 'measure': 41},
                                {'domain': 5, 'measure': 110},
                                {'domain': 6, 'measure': 17},
                                {'domain': 7, 'measure': 127},
                                {'domain': 8, 'measure': 78},
                                {'domain': 9, 'measure': 89},
                                {'domain': 10, 'measure': 187},
                                {'domain': 11, 'measure': 148},
                                {'domain': 12, 'measure': 127},
                              ],
                            },
                          ],
                          lineColor: (lineData, index, id) => Colors.amber,
                        ),
                      ),
                      const Text('Month ---->')
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
