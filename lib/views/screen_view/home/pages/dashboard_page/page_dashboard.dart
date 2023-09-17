import 'package:flutter/material.dart';
import 'package:trading_edge/utils/constants/colors.dart';
import 'package:trading_edge/utils/constants/const_values.dart';
import 'package:trading_edge/utils/constants/constant_widgets.dart';
import 'package:trading_edge/views/screen_view/home/pages/dashboard_page/widgets/widget_fund_movement.dart';
import 'package:trading_edge/views/screen_view/home/pages/dashboard_page/widgets/widget_pnl_analysis_graph.dart';

import 'widgets/choice_chip_item.dart';
import 'widgets/pnl_section.dart';

class PageDashboard extends StatelessWidget {
  const PageDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(
                height: 60,
              ),
              const PnLDetailsSection(),
              sizedBoxTen,
              //ffffffffffffffffffffffffffffffffffffffffffffffff
              WidgetPnlAnalysis(
                selectedIdex: 0,
              ),
              sizedBoxTen,
              const WidgetFundMovement(),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                color: whiteColor,
                border: Border.all(
                    color: const Color.fromARGB(255, 221, 220, 220),
                    width: 0.5)),
            height: 45,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(left: 7, right: 7),
              child: ListView.builder(
                itemCount: choiceChipNameList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => ChoiceChipItem(
                  index: index,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
