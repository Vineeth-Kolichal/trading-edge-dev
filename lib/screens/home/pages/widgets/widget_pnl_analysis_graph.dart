import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:my_tradebook/main.dart';
import 'package:my_tradebook/screens/home/pages/widgets/widget_pnl_analysis_graph_description.dart';

class WidgetPnlAnalysis extends StatelessWidget {
  final Map<String, int> graphValue;
  const WidgetPnlAnalysis({super.key, required this.graphValue});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: whiteColor,
      borderRadius: BorderRadius.circular(13),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const Text(
              'P&L Analysis',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: DChartPie(
                  data: [
                    {
                      'domain': 'Profit-swing',
                      'measure': graphValue['Profit-swing']
                    },
                    {
                      'domain': 'Loss-swing',
                      'measure': graphValue['Loss-swing']
                    },
                    {
                      'domain': 'Profit-intraday',
                      'measure': graphValue['Profit-intraday']
                    },
                    {
                      'domain': 'Loss-intraday',
                      'measure': graphValue['Loss-intraday']
                    },
                  ],
                  fillColor: (pieData, index) {
                    switch (pieData['domain']) {
                      case 'Profit-swing':
                        return const Color.fromARGB(255, 35, 204, 1);
                      case 'Loss-swing':
                        return const Color.fromARGB(255, 245, 3, 3);
                      case 'Profit-intraday':
                        return const Color.fromARGB(255, 121, 241, 110);
                      case 'Loss-intraday':
                        return const Color.fromARGB(255, 245, 126, 117);
                      default:
                        return Colors.purple.shade900;
                    }
                  },
                  donutWidth: 25, labelFontSize: 10,
                  //labelColor: Colors.white,
                  pieLabel: (pieData, index) {
                    return "${pieData['measure']}%";
                  },
                  labelPosition: PieLabelPosition.outside,
                ),
              ),
            ),
            pnlGraphComponent(),
          ],
        ),
      ),
    );
  }
}
