import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:my_tradebook/main.dart';

class WidgetFundMovement extends StatelessWidget {
  final List<Map<String, dynamic>> chartData;
  const WidgetFundMovement({super.key, required this.chartData});

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
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RotatedBox(
                          quarterTurns: 3,
                          child: const Icon(Icons.arrow_forward, size: 17)),
                      const RotatedBox(quarterTurns: 3, child: Text('Fund')),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.25,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: DChartLine(
                          includePoints: true,
                          data: [
                            {
                              'id': 'Line',
                              'data': chartData,
                            },
                          ],
                          lineColor: (lineData, index, id) =>
                              customPrimaryColor,
                              
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Month '),
                          const Icon(Icons.arrow_forward, size: 17),
                        ],
                      )
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
