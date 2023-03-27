import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class WidgetFUndMovement extends StatelessWidget {
  const WidgetFUndMovement({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(13),
      elevation: 3,
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
                        width: 300,
                        child: DChartLine(
                          includePoints: true,
                          data: [
                            {
                              'id': 'Line',
                              'data': [
                                {'domain': 1, 'measure': 10},
                                {'domain': 2, 'measure': 0},
                                {'domain': 3, 'measure': 1},
                                {'domain': 4, 'measure': 1},
                                {'domain': 5, 'measure': 110},
                                {'domain': 6, 'measure': 1},
                                {'domain': 7, 'measure': 1},
                                {'domain': 8, 'measure': 1},
                                {'domain': 9, 'measure': 1},
                                {'domain': 10, 'measure': 1},
                                {'domain': 11, 'measure': 1},
                                {'domain': 12, 'measure': 1},
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
