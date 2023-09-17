import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:trading_edge/database/firebase/dashbord_calculations/pie_graph_data.dart';
import 'package:trading_edge/main.dart';
import 'package:trading_edge/views/screens/home/pages/widgets/widget_pnl_analysis_graph_description.dart';
import 'package:trading_edge/views/widgets/no_data_animation.dart';

// ignore: must_be_immutable
class WidgetPnlAnalysis extends StatelessWidget {
  final int selectedIdex;
  List<String> titles = ['last day', 'Weekly', 'Quarterly', 'FY'];
  WidgetPnlAnalysis({super.key, required this.selectedIdex});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: whiteColor,
      borderRadius: BorderRadius.circular(13),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                'P&L Analysis',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: FutureBuilder(
                      future: pieGraphValues(selectedIdex),
                      builder: (context, snapshot) {
                        if (snapshot.data == null) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const NoDataAnimation(),
                              Text('No ${titles[selectedIdex]} data found🧐')
                            ],
                          );
                        } else {
                          Map<String, int>? doughNutValue = snapshot.data;
                          if (doughNutValue != null) {
                            return DChartPie(
                              data: [
                                {
                                  'domain': 'Profit-swing',
                                  'measure': doughNutValue['Profit-swing']
                                },
                                {
                                  'domain': 'Loss-swing',
                                  'measure': doughNutValue['Loss-swing']
                                },
                                {
                                  'domain': 'Profit-intraday',
                                  'measure': doughNutValue['Profit-intraday']
                                },
                                {
                                  'domain': 'Loss-intraday',
                                  'measure': doughNutValue['Loss-intraday']
                                },
                              ],
                              fillColor: (pieData, index) {
                                switch (pieData['domain']) {
                                  case 'Profit-swing':
                                    return const Color.fromARGB(
                                        255, 35, 204, 1);
                                  case 'Loss-swing':
                                    return const Color.fromARGB(255, 245, 3, 3);
                                  case 'Profit-intraday':
                                    return const Color.fromARGB(
                                        255, 121, 241, 110);
                                  case 'Loss-intraday':
                                    return const Color.fromARGB(
                                        255, 245, 126, 117);
                                  default:
                                    return Colors.purple.shade900;
                                }
                              },
                              donutWidth: 25,
                              labelFontSize: 10,
                              pieLabel: (pieData, index) {
                                return "${pieData['measure']}%";
                              },
                              labelPosition: PieLabelPosition.outside,
                            );
                          } else {
                            return const Column(
                              children: [
                                NoDataAnimation(),
                                Text('No data found!')
                              ],
                            );
                          }
                        }
                      }),
                ),
              ),
              pnlGraphComponent(context),
            ],
          ),
        ),
      ),
    );
  }
}
