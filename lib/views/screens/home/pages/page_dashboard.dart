import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:trading_edge/database/firebase/dashbord_calculations/pnl_calculations.dart';
import 'package:trading_edge/database/firebase/dashbord_calculations/pnl_percentage_calculation.dart';
import 'package:trading_edge/database/firebase/dashbord_calculations/total_pnl_section.dart';
import 'package:trading_edge/functions/function_short_amount.dart';
import 'package:trading_edge/main.dart';
import 'package:trading_edge/utils/constants/constant_widgets.dart';
import 'package:trading_edge/views/screens/home/pages/widgets/widget_fund_movement.dart';
import 'package:trading_edge/views/screens/home/pages/widgets/widget_pnl_analysis_graph.dart';
import 'package:trading_edge/views/widgets/widget_circular_progress.dart';

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
              Material(
                color: whiteColor,
                borderRadius: BorderRadius.circular(13),
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 80,
                          width: 130,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            //  mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const AutoSizeText(
                                'Current Balance',
                                maxLines: 1,
                              ),
                              sizedBoxTen,
                              FutureBuilder(
                                  future: getCurrentBalance(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<double>
                                          currentBalancesnapshot) {
                                    if (currentBalancesnapshot.data == null) {
                                      return const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  customPrimaryColor),
                                        ),
                                      );
                                    }
                                    double currentBalance =
                                        currentBalancesnapshot.data!;

                                    return Tooltip(
                                      textStyle: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                      waitDuration:
                                          const Duration(milliseconds: 100),
                                      showDuration:
                                          const Duration(milliseconds: 5000),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey, width: 0.4),
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: const LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            whiteColor,
                                            Color.fromARGB(255, 238, 238, 247),
                                          ],
                                        ),
                                      ),
                                      message: "₹ $currentBalance",
                                      child: AutoSizeText(
                                        '₹$currentBalance',
                                        style: const TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.w700),
                                        maxLines: 1,
                                      ),
                                    );
                                  }),
                            ],
                          ),
                        ),
                        const VerticalDivider(
                          width: 20,
                          thickness: 1,
                          indent: 0,
                          endIndent: 0,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          height: 100,
                          width: 130,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AutoSizeText(
                                  maxLines: 1, pnlTitle[_selectedIdex]),
                              sizedBoxTen,
                              FutureBuilder(
                                  future: totalPnlCalculations(_selectedIdex),
                                  builder: (context, snapshot) {
                                    if (snapshot.data == null) {
                                      return progress;
                                    } else {
                                      return Tooltip(
                                        textStyle: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500),
                                        waitDuration:
                                            const Duration(milliseconds: 100),
                                        showDuration:
                                            const Duration(milliseconds: 5000),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey, width: 0.4),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          gradient: const LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              whiteColor,
                                              Color.fromARGB(
                                                  255, 238, 238, 247),
                                            ],
                                          ),
                                        ),
                                        message: "${snapshot.data}",
                                        child: (snapshot.data! >= 0)
                                            ? AutoSizeText(
                                                maxLines: 1,
                                                '+${shortenNumber(snapshot.data!)}',
                                                style: const TextStyle(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.green),
                                              )
                                            : AutoSizeText(
                                                maxLines: 1,
                                                '-${shortenNumber(snapshot.data!)}',
                                                style: const TextStyle(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.red),
                                              ),
                                      );
                                    }
                                  }),
                              FutureBuilder(
                                  future: percentageCalculations(_selectedIdex),
                                  builder: (context, snapshot) {
                                    if (snapshot.data == null) {
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: progress,
                                      );
                                    } else {
                                      return Text(
                                        "${snapshot.data?.toStringAsFixed(2)}%",
                                        style: TextStyle(
                                            color: (snapshot.data! < 0.0
                                                ? Colors.red
                                                : Colors.green)),
                                      );
                                    }
                                  }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
