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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Fund Movement(Last 10 week)',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  width: 10,
                ),
                Tooltip(
                  textStyle: const TextStyle(
                      color: Color.fromARGB(255, 94, 92, 92),
                      fontWeight: FontWeight.w500),
                  waitDuration: const Duration(milliseconds: 100),
                  showDuration: const Duration(milliseconds: 5000),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 0.4),
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        whiteColor,
                        Color.fromARGB(255, 238, 238, 247),
                      ],
                    ),
                    // color: customPrimaryColor[200],
                  ),
                  message:
                      "Only the cash flows of the weeks during\nwhich you took trades are shown in this chart. \nIf you did not take any trades in a particular \nweek, that week will be ignored in the chart.",
                  child: const Icon(
                    Icons.info,
                    size: 17,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 250,
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
