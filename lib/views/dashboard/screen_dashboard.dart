import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:my_tradebook/core/constants/colors.dart';
import 'package:my_tradebook/views/dashboard/widgets/widget_fund_movement.dart';
import 'package:my_tradebook/views/dashboard/widgets/widget_pnl_analysis_graph.dart';
import 'package:my_tradebook/views/login/screen_login.dart';

import 'widgets/balance_and_pnl_section.dart';

class PageDashboard extends StatefulWidget {
  const PageDashboard({super.key});

  @override
  State<PageDashboard> createState() => _PageDashboardState();
}

class _PageDashboardState extends State<PageDashboard> {
  var _selectedIdex = 0;
  final List<String> pnlTitle = [
    "Last day's P&L",
    'This week P&L',
    'This quarter P&L',
    'This FY P&L'
  ];
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              const SizedBox(
                height: 60,
              ),
              BalanceAndPnlSection(pnlTitle: pnlTitle, selectedIdex: _selectedIdex),
              sizedBoxTen,
              WidgetPnlAnalysis(
                selectedIdex: _selectedIdex,
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
          child: Material(
            color: whiteColor,
            borderRadius: BorderRadius.circular(13),
            elevation: 1,
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              height: 45,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 7, right: 7),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: choiceChipList(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  final List<String> _choiceChipNameList = [
    'Last Day',
    'This week',
    'This Quarter',
    'Current FY'
  ];

  List<Widget> choiceChipList() {
    List<Widget> chips = [];
    for (var i = 0; i < _choiceChipNameList.length; i++) {
      Widget item = Padding(
        padding: const EdgeInsets.only(right: 5),
        child: ChoiceChip(
          pressElevation: 0,
          elevation: 0,
          backgroundColor: whiteColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          label: AutoSizeText(_choiceChipNameList[i],
              maxLines: 1,
              style: TextStyle(
                  color: (_selectedIdex == i) ? Colors.white : Colors.black)),
          selected: _selectedIdex == i,
          selectedColor: customPrimaryColor,
          onSelected: (value) {
            setState(() {
              _selectedIdex = i;
            });
          },
        ),
      );
      chips.add(item);
    }
    return chips;
  }
}

