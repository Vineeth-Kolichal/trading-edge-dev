import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:trading_edge/database/firebase/dashbord_calculations/bar_graph_data.dart';
import 'package:trading_edge/utils/constants/colors.dart';
import 'package:trading_edge/views/widgets/no_data_animation.dart';

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
                  waitDuration: const Duration(milliseconds: 0),
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
                            return const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                NoDataAnimation(),
                                Text('No  data found')
                              ],
                            );
                          } else {
                            List<Map<String, dynamic>> data = snapshot.data!;
                            int flag = 0;
                            for (var element in data) {
                              if (element['measure'] != 0.0) {
                                flag = 1;
                              }
                            }
                            if (flag == 1) {
                              return DChartBarCustom(
                                measureLabelStyle: const TextStyle(fontSize: 9),
                                showDomainLine: true,
                                showMeasureLine: true,
                                showDomainLabel: true,
                                showMeasureLabel: true,
                                spaceBetweenItem: 8,
                                listData: chartBarItemList(data),
                              );
                            } else {
                              return const Center(
                                child: Text(
                                  'No data found to show graph 🧐',
                                  textAlign: TextAlign.center,
                                ),
                              );
                            }
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
        color: (value > valuePrev) ? greenTextColor : redTextColor);
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
