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
    double prevVal = double.negativeInfinity;
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
                      "👉Only the cash flows of the weeks during\nwhich you took trades are shown in this chart. \nIf you did not take any trades in a particular \nweek, that week will be ignored in the chart.\n👉 In chart Week 10 shows the fund\nmovement of current week",
                  child: const Icon(
                    Icons.info,
                    size: 17,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 210,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 160,
                    //height: MediaQuery.of(context).size.height * 0.25,
                    width: MediaQuery.of(context).size.width * 0.85,
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
                            prevVal = double.negativeInfinity;
                            List<Map<String, dynamic>> data = snapshot.data!;
                            return // example 1
                                DChartBarCustom(
                              measureLabelStyle: TextStyle(fontSize: 9),
                              showDomainLine: true,
                              showMeasureLine: true,
                              showDomainLabel: true,
                              showMeasureLabel: true,
                              spaceBetweenItem: 8,
                              listData: chartBarItemList(data),
                            );
                            // return DChartBar(
                            //   data: [
                            //     {
                            //       'id': 'Bar',
                            //       'data': snapshot.data,
                            //     },
                            //   ],
                            //   domainLabelPaddingToAxisLine: 16,
                            //   yAxisTitle: 'Week',
                            //   xAxisTitle: 'Fund',
                            //   axisLineTick: 2,
                            //   axisLinePointTick: 2,
                            //   axisLinePointWidth: 10,
                            //   axisLineColor: Colors.black,
                            //   measureLabelPaddingToAxisLine: 16,
                            //   verticalDirection: false,
                            //   barValuePosition: BarValuePosition.auto,
                            //   barValueAnchor: BarValueAnchor.end,
                            //   barValueColor: whiteColor,
                            //   barValueFontSize: 8,
                            //   barValue: (barData, index) =>
                            //       '${barData['measure']}',
                            //   barColor: (barData, index, id) {
                            //     double measure = barData['measure'];
                            //     if (measure > prevVal) {
                            //       prevVal = measure;
                            //       return Colors.green;
                            //     } else if (measure < prevVal) {
                            //       prevVal = measure;
                            //       return Colors.red;
                            //     } else {
                            //       return Colors.green;
                            //     }
                            //   },
                            //   showBarValue: true,
                            // );

                            // return DChartLine(
                            //   includePoints: true,
                            //   data: [
                            //     {
                            //       'id': 'Line',
                            //       'data': snapshot.data,
                            //     },
                            //   ],
                            //   lineColor: (lineData, index, id) =>
                            //       customPrimaryColor,
                            // );
                          }
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  DChartBarDataCustom customChartBarItem(
      {required double value,
      required double valuePrev,
      required String label}) {
    return DChartBarDataCustom(
        value: value,
        labelCustom: Transform.rotate(
          angle: 5.3,
          child: Text(
            label,
            style: const TextStyle(fontSize: 6),
          ),
        ),
        label: label,
        color: (value > valuePrev) ? Colors.green : Colors.red);
  }

  List<DChartBarDataCustom> chartBarItemList(List<Map<String, dynamic>> data) {
    List<DChartBarDataCustom> chartList = [];
    for (var i = 0; i < data.length; i++) {
      if (i == 0) {
        chartList.add(customChartBarItem(
            value: data[i]['measure'], valuePrev: 0, label: data[i]['domain']));
      } else {
        chartList.add(customChartBarItem(
            value: data[i]['measure'],
            valuePrev: data[i - 1]['measure'],
            label: data[i]['domain']));
      }
    }
    return chartList;
  }
}
