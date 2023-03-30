import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:my_tradebook/main.dart';
import 'package:my_tradebook/screens/home/pages/widgets/widget_pnl_analysis_graph_description.dart';

class WidgetPnlAnalysis extends StatelessWidget {
  const WidgetPnlAnalysis({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(color: whiteColor,
      borderRadius: BorderRadius.circular(13),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text(
              'P&L Analysis',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 160,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: DChartPie(
                  data: [
                    {'domain': 'profit_swing', 'measure': 28},
                    {'domain': 'loss_swing', 'measure': 27},
                    {'domain': 'profit_intraday', 'measure': 30},
                    {'domain': 'loss_intraday', 'measure': 15},
                  ],
                  fillColor: (pieData, index) {
                    switch (pieData['domain']) {
                      case 'profit_swing':
                        return Color.fromARGB(255, 35, 204, 1);
                      case 'loss_swing':
                        return Color.fromARGB(255, 245, 3, 3);
                      case 'profit_intraday':
                        return Color.fromARGB(255, 121, 241, 110);
                      case 'loss_intraday':
                        return Color.fromARGB(255, 245, 126, 117);
                      default:
                        return Colors.purple.shade900;
                    }
                  },
                  donutWidth: 25,
                  labelColor: Colors.white,
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
