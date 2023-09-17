import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trading_edge/utils/constants/colors.dart';
import 'package:trading_edge/view_model/dashboard_page_viewmodel/dashboard_page_viewmodel.dart';
import 'package:trading_edge/views/screen_view/home/pages/dashboard_page/widgets/widget_pnl_analysis_graph_description.dart';
import 'package:trading_edge/views/widgets/no_data_animation.dart';

// ignore: must_be_immutable
class WidgetPnlAnalysis extends StatelessWidget {
  final int selectedIdex;
  List<String> titles = ['last day', 'Weekly', 'Quarterly', 'FY'];
  WidgetPnlAnalysis({super.key, required this.selectedIdex});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: whiteColor, borderRadius: BorderRadius.circular(13)),
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
                  child: Selector<DashboardPageViewModel, Map<String, int>>(
                      selector: (p0, p1) => p1.pieChartData,
                      builder: (context, pieGraphData, _) {
                        Map<String, int> doughNutValue = pieGraphData;
                        if (doughNutValue.isNotEmpty) {
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
                                  return const Color.fromARGB(255, 35, 204, 1);
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
