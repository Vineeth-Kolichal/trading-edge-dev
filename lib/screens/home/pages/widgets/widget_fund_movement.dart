import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:my_tradebook/database/firebase/dashbord_calculations/line_graph_data.dart';
import 'package:my_tradebook/main.dart';
import 'package:my_tradebook/widgets/widget_search_gif.dart';

class WidgetFundMovement extends StatelessWidget {
  const WidgetFundMovement({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: whiteColor,
      borderRadius: BorderRadius.circular(13),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 5, right: 5, left: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              'Fund Movement(Last 10 week)',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 250,
             // height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      RotatedBox(
                          quarterTurns: 3,
                          child: Icon(Icons.arrow_forward, size: 17)),
                      RotatedBox(quarterTurns: 3, child: Text('Fund')),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Column(
                    children: [
                      SizedBox(
                        height: 200,
                        //height: MediaQuery.of(context).size.height * 0.25,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: FutureBuilder(
                            future: lineGraphData(),
                            builder: (context, snapshot) {
                              if (snapshot.data == null) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    WidgetSearchGif(),
                                    Text('No  data found')
                                  ],
                                );
                              } else {
                                return DChartLine(
                                  includePoints: true,
                                  data: [
                                    {
                                      'id': 'Line',
                                      'data': snapshot.data,
                                    },
                                  ],
                                  lineColor: (lineData, index, id) =>
                                      customPrimaryColor,
                                );
                              }
                            }),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('Week '),
                          Icon(Icons.arrow_forward, size: 17),
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
