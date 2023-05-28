import 'package:auto_size_text/auto_size_text.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:my_tradebook/core/constants/colors.dart';
import 'package:my_tradebook/services/firebase/dashbord_calculations/pnl_calculations.dart';
import 'package:my_tradebook/services/firebase/dashbord_calculations/pnl_percentage_calculation.dart';
import 'package:my_tradebook/services/functions/function_short_amount.dart';
import 'package:my_tradebook/views/login/screen_login.dart';

class ProfitOrLoss extends StatelessWidget {
  const ProfitOrLoss({
    super.key,
    required this.pnlTitle,
    required int selectedIdex,
  }) : _selectedIdex = selectedIdex;

  final List<String> pnlTitle;
  final int _selectedIdex;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                  return const FadeShimmer(
                    millisecondsDelay: 10,
                    height: 20,
                    width: 100,
                    radius: 4,
                    highlightColor: Color(0xffF9F9FB),
                    baseColor: Color(0xffE6E8EB),
                  );
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
                  return const Padding(
                    padding:  EdgeInsets.only(top: 5),
                    child:  FadeShimmer(
                      millisecondsDelay: 10,
                      height: 20,
                      width: 60,
                      radius: 4,
                      highlightColor: Color(0xffF9F9FB),
                      baseColor: Color(0xffE6E8EB),
                    ),
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
    );
  }
}